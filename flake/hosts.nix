{
  inputs,
  lib,
  ...
}:
let
  # Map of nixpkgs source inputs, keyed by channel name.
  nixpkgsSources = {
    stable-2605 = inputs.nixpkgs-2605;
    unstable = inputs.nixpkgs-unstable;
  };

  pkgsCache = lib.genAttrs [ "x86_64-linux" "aarch64-linux" ] (
    system:
    lib.mapAttrs (
      _: src:
      import src {
        inherit system;
        config.allowUnfree = true;
      }
    ) nixpkgsSources
  );

  moduleHelpers = import ../lib/module-helpers.nix { inherit lib; };

  specialArgs = { inherit inputs moduleHelpers; };

  mkHostConfig = import ../lib/mksystem.nix {
    inherit
      inputs
      moduleHelpers
      pkgsCache
      ;
  };
  hosts = import ../systems/systems.nix { inherit lib; };

  hostConfigs = lib.mapAttrs mkHostConfig hosts;
  deployableHostConfigs = lib.filterAttrs (_: cfg: cfg.host.ip != null) hostConfigs;

  nixosSystemParity = {
    nixpkgs.flake.source = inputs.nixpkgs.outPath;
    system.nixos = {
      versionSuffix = inputs.nixpkgs.lib.trivial.versionSuffix;
      revision = inputs.nixpkgs.lib.trivial.revisionWithDefault null;
    };
  };
in
{
  flake = {
    nixosConfigurations = lib.mapAttrs (
      _: cfg:
      lib.nixosSystem {
        inherit (cfg) system modules;
        inherit specialArgs;
      }
    ) hostConfigs;

    colmenaHive = inputs.colmena.lib.makeHive (
      {
        meta = {
          nixpkgs = pkgsCache.x86_64-linux.unstable;
          nodeNixpkgs = lib.mapAttrs (_: cfg: pkgsCache.${cfg.system}.unstable) deployableHostConfigs;
          inherit specialArgs;
        };
      }
      // lib.mapAttrs (_: cfg: {
        deployment = {
          targetHost = cfg.host.ip;
          targetUser = cfg.host.deployUser;
          targetPort = cfg.host.port;
          buildOnTarget = true;
          # `colmena apply-local --sudo` on the host itself (needs a local checkout).
          allowLocalDeployment = true;
        };
        imports = cfg.modules ++ [ nixosSystemParity ];
      }) deployableHostConfigs
    );
  };

  # Per-channel package sets, a module argument of the perSystem modules (flake/dev.nix).
  perSystem =
    { system, ... }:
    {
      _module.args.pkgsSets = pkgsCache.${system};
    };
}
