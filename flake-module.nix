# flake-module.nix — NixOS host configurations, Colmena hive and deploy-rs nodes.
# Imported by flake.nix via flake-parts `imports`.
{ inputs, lib, self, ... }:
let
  # Map of nixpkgs source inputs, keyed by channel name.
  nixpkgsSources = {
    stable   = inputs.nixpkgs-stable;
    unstable = inputs.nixpkgs-unstable;
    master   = inputs.nixpkgs-master;
  };

  # Pre-built pkgs sets per architecture, keyed by system then channel.
  # Shape: { "x86_64-linux" = { stable = pkgs; unstable = pkgs; master = pkgs; }; ... }
  pkgsCache = lib.genAttrs [ "x86_64-linux" ] (system:
    lib.mapAttrs (_: src: import src {
      inherit system;
      config.allowUnfree = true;
    }) nixpkgsSources
  );

  moduleHelpers = import ./lib/module-helpers.nix { inherit lib; };

  mkHostConfig = import ./lib/mksystem.nix { inherit inputs lib pkgsCache moduleHelpers; };
  hosts        = import ./systems/systems.nix { inherit lib; };

  hostConfigs           = lib.mapAttrs mkHostConfig hosts;
  deployableHostConfigs = lib.filterAttrs (_: cfg: cfg.host.ip != null) hostConfigs;
in {
  flake.nixosConfigurations = lib.mapAttrs (name: cfg: lib.nixosSystem {
    inherit (cfg) system;
    specialArgs = {
      inherit inputs moduleHelpers;
    };
    modules = cfg.modules;
  }) hostConfigs;

  flake.colmenaHive = inputs.colmena.lib.makeHive ({
    meta = {
      nixpkgs     = import inputs.nixpkgs { system = "x86_64-linux"; };
      specialArgs = { inherit inputs moduleHelpers; };
    };
  } // (lib.mapAttrs (name: cfg: {
    deployment = {
      targetHost           = cfg.host.ip;
      targetUser           = cfg.host.deployUser;
      targetPort           = cfg.host.port;
      buildOnTarget        = true;
      allowLocalDeployment = false;
    };
    imports = cfg.modules;
  }) deployableHostConfigs));

  flake.deploy = {
    nodes = lib.mapAttrs (name: cfg: {
      hostname = cfg.host.ip;
      profiles.system = {
        user    = cfg.host.deployUser;
        sshUser = cfg.host.deployUser;
        # Self-reference: resolved lazily after nixosConfigurations is built.
        path    = inputs.deploy-rs.lib.${cfg.system}.activate.nixos self.nixosConfigurations.${name};
      };
    }) deployableHostConfigs;
  };
}
