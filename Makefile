HASH := \#

NIX := nix --extra-experimental-features "nix-command flakes"

SERVERS ?= $(shell $(NIX) eval --raw .$(HASH)nixosConfigurations --apply 'c: toString (builtins.attrNames c)' 2>/dev/null)

COLMENA_FLAGS := --show-trace --verbose
# --no-build-on-target
COLMENA_BUILD_FLAGS ?=

.PHONY: update check fmt gc build-all all-systems

build-all:
	@$(NIX) run github:Mic92/nix-fast-build -- \
		--flake ".$(HASH)nixosConfigurations" \
		--select "configs: builtins.mapAttrs (name: cfg: cfg.config.system.build.toplevel) configs" \
		--skip-cached

update:
	@$(NIX) flake update

check:
	@$(NIX) flake check -L

fmt:
	@$(NIX) fmt .

gc:
	@nix-collect-garbage --delete-older-than 7d

all-systems:
	@$(NIX) flake show . --all-systems --no-write-lock-file

define SERVER_RULES
.PHONY: $(1).test $(1).build $(1).push $(1).boot $(1).vm $(1).sbom

$(1).test:
	@$(NIX) build .$(HASH)nixosConfigurations.$(1).config.system.build.toplevel --dry-run --show-trace --verbose

$(1).build:
	@$(NIX) build .$(HASH)nixosConfigurations.$(1).config.system.build.toplevel -o result-$(1) --show-trace --verbose

# Colmena only knows hosts with an `ip` (see flake/hosts.nix).
$(1).push:
	@colmena apply $(COLMENA_FLAGS) $(COLMENA_BUILD_FLAGS) --on $(1)

$(1).boot:
	@colmena apply boot $(COLMENA_FLAGS) $(COLMENA_BUILD_FLAGS) --reboot --on $(1)

$(1).vm:
	@$(NIX) build .$(HASH)nixosConfigurations.$(1).config.system.build.vm --show-trace

$(1).sbom: $(1).build
	@$(NIX) run nixpkgs$(HASH)sbomnix -- "./result-$(1)" \
		--csv "sbom-$(1).csv" \
		--cdx "sbom-$(1).cdx.json" \
		--spdx "sbom-$(1).spdx.json"

endef

$(foreach server,$(SERVERS),$(eval $(call SERVER_RULES,$(server))))
