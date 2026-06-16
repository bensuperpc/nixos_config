{ inputs, lib, self, ... }:
let
  # Map of nixpkgs source inputs, keyed by channel name.
  nixpkgsSources = {
    stable-2605 = inputs.nixpkgs-2605;
    stable-2511 = inputs.nixpkgs-2511;
    stable-2505 = inputs.nixpkgs-2505;
    unstable = inputs.nixpkgs-unstable;
    master   = inputs.nixpkgs-master;
  };

  pkgsCache = lib.genAttrs [ "x86_64-linux" "aarch64-linux" ] (system:
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

  perSystem = { pkgs, ... }@args: 
  let
    pkgsSets = pkgsCache.${args.system};
  in
  {
    devShells = import ./devshells { inherit pkgs pkgsSets; };

    checks.deadnix = pkgs.runCommand "deadnix-check" {
      nativeBuildInputs = [ pkgs.deadnix ];
    } ''
      deadnix -f -L ${self}
      touch $out
    '';
  };

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
