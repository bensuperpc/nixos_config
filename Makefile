DIR := $(CURDIR)

SERVERS := server-1-m710q fluttershy

DOCKER_NIX_VOL := nix-store-vol
DOCKER_NIX := docker run -it --rm \
    -v $(DIR):/etc/nixos -w /etc/nixos \
	-v $(DOCKER_NIX_VOL):/nix \
	nixos/nix:latest

NIX_FLAGS := --extra-experimental-features "nix-command flakes"
GIT_FIX := git config --global --add safe.directory /etc/nixos
COLMENA_FLAGS := --show-trace --verbose

.PHONY: help update update-input check fmt clean repl gc

update:
	@$(DOCKER_NIX) sh -c '$(GIT_FIX) && nix $(NIX_FLAGS) flake update'

check:
	@$(DOCKER_NIX) sh -c '$(GIT_FIX) && nix $(NIX_FLAGS) flake check'

fmt:
	@$(DOCKER_NIX) sh -c '$(GIT_FIX) && nix $(NIX_FLAGS) fmt'

gc:
	@$(DOCKER_NIX) sh -c '$(GIT_FIX) && nix-collect-garbage --delete-older-than 7d'

all-systems:
	@$(DOCKER_NIX) sh -c '$(GIT_FIX) && nix $(NIX_FLAGS) flake show path:. --all-systems --no-write-lock-file'

define SERVER_RULES
.PHONY: $(1).test $(1).build $(1).push $(1).vm

$(1).test:
	@$(DOCKER_NIX) sh -c '$(GIT_FIX) && nix $(NIX_FLAGS) build path:/etc/nixos#nixosConfigurations.$(1).config.system.build.toplevel --dry-run --show-trace --verbose'

$(1).build:
	@$(DOCKER_NIX) sh -c '$(GIT_FIX) && nix $(NIX_FLAGS) build path:/etc/nixos#nixosConfigurations.$(1).config.system.build.toplevel --show-trace --verbose'

$(1).push:
	@colmena apply $(COLMENA_FLAGS) --on $(1)

$(1).boot:
	@colmena apply boot $(COLMENA_FLAGS) --reboot --on $(1)

$(1).vm:
	@$(DOCKER_NIX) sh -c '$(GIT_FIX) && nix $(NIX_FLAGS) build path:/etc/nixos#nixosConfigurations.$(1).config.system.build.vm --show-trace'
endef

$(foreach server,$(SERVERS),$(eval $(call SERVER_RULES,$(server))))