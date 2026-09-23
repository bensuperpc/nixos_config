DIR := $(CURDIR)
HASH := \#

NIX_FLAGS := --extra-experimental-features "nix-command flakes"

SERVERS ?= $(shell nix $(NIX_FLAGS) eval --raw .$(HASH)nixosConfigurations --apply 'c: toString (builtins.attrNames c)' 2>/dev/null)

DOCKER_NIX_VOL := nix-store-vol
DOCKER_TTY := $(shell [ -t 0 ] && echo -t)
DOCKER_NIX := docker run -i $(DOCKER_TTY) --rm \
	-v $(DIR):/etc/nixos -w /etc/nixos \
	-v $(DOCKER_NIX_VOL):/nix \
	nixos/nix:latest

GIT_FIX := git config --global --add safe.directory /etc/nixos
COLMENA_FLAGS := --show-trace --verbose
# --no-build-on-target
COLMENA_BUILD_FLAGS ?=

.PHONY: help update update-input check fmt clean repl gc build-all all-systems

build-all:
	@$(DOCKER_NIX) sh -c '$(GIT_FIX) && nix $(NIX_FLAGS) run github:Mic92/nix-fast-build -- \
		--flake ".#nixosConfigurations" \
		--select "configs: builtins.mapAttrs (name: cfg: cfg.config.system.build.toplevel) configs" \
		--skip-cached'

update:
	@$(DOCKER_NIX) sh -c '$(GIT_FIX) && nix $(NIX_FLAGS) flake update'

check:
	@$(DOCKER_NIX) sh -c '$(GIT_FIX) && nix $(NIX_FLAGS) flake check -L'

fmt:
	@$(DOCKER_NIX) sh -c '$(GIT_FIX) && nix $(NIX_FLAGS) fmt .'

gc:
	@$(DOCKER_NIX) sh -c '$(GIT_FIX) && nix-collect-garbage --delete-older-than 7d'

all-systems:
	@$(DOCKER_NIX) sh -c '$(GIT_FIX) && nix $(NIX_FLAGS) flake show . --all-systems --no-write-lock-file'

define SERVER_RULES
.PHONY: $(1).test $(1).build $(1).push $(1).boot $(1).vm $(1).sbom

$(1).test:
	@$(DOCKER_NIX) sh -c '$(GIT_FIX) && nix $(NIX_FLAGS) build .$(HASH)nixosConfigurations.$(1).config.system.build.toplevel --dry-run --show-trace --verbose'

$(1).build:
	@$(DOCKER_NIX) sh -c '$(GIT_FIX) && nix $(NIX_FLAGS) build .$(HASH)nixosConfigurations.$(1).config.system.build.toplevel -o result-$(1) --show-trace --verbose'

# Colmena only knows hosts with an `ip` (see flake-module.nix).
$(1).push:
	@colmena apply $(COLMENA_FLAGS) $(COLMENA_BUILD_FLAGS) --on $(1)

$(1).boot:
	@colmena apply boot $(COLMENA_FLAGS) $(COLMENA_BUILD_FLAGS) --reboot --on $(1)

$(1).vm:
	@$(DOCKER_NIX) sh -c '$(GIT_FIX) && nix $(NIX_FLAGS) build .$(HASH)nixosConfigurations.$(1).config.system.build.vm --show-trace'

$(1).sbom: $(1).build
	@$(DOCKER_NIX) sh -c '$(GIT_FIX) && nix $(NIX_FLAGS) run nixpkgs#sbomnix -- "./result-$(1)" \
		--csv "sbom-$(1).csv" \
		--cdx "sbom-$(1).cdx.json" \
		--spdx "sbom-$(1).spdx.json"'

endef

$(foreach server,$(SERVERS),$(eval $(call SERVER_RULES,$(server))))
