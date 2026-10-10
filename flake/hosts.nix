{
  inputs,
  lib,
  ...
}:
let
  channels = {
    stable-2605 = {
      nixpkgs = inputs.nixpkgs-2605;
      homeManager = inputs.home-manager-2605;
    };
    unstable = {
      nixpkgs = inputs.nixpkgs-unstable;
      homeManager = inputs.home-manager;
    };
  };

  pkgsCache = lib.genAttrs [ "x86_64-linux" "aarch64-linux" ] (
    system:
    lib.mapAttrs (
      _: channel:
      import channel.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      }
    ) channels
  );

  moduleHelpers = import ../lib/module-helpers.nix { inherit lib; };

  specialArgs = { inherit inputs moduleHelpers; };

  mkHostConfig = import ../lib/mksystem.nix {
    inherit
      inputs
      moduleHelpers
      pkgsCache
      channels
      ;
  };
  hosts = import ../systems/systems.nix {
    inherit lib;
    channels = lib.attrNames channels;
  };

  hostConfigs = lib.mapAttrs mkHostConfig hosts;
  deployableHostConfigs = lib.filterAttrs (_: cfg: cfg.host.ip != null) hostConfigs;

  nixosSystemParity = nixpkgs: {
    nixpkgs.flake.source = nixpkgs.outPath;
    system.nixos = {
      versionSuffix = nixpkgs.lib.trivial.versionSuffix;
      revision = nixpkgs.lib.trivial.revisionWithDefault null;
    };
  };
in
{
  flake = {
    nixosConfigurations = lib.mapAttrs (
      _: cfg:
      channels.${cfg.channel}.nixpkgs.lib.nixosSystem {
        inherit (cfg) system modules;
        inherit specialArgs;
      }
    ) hostConfigs;

    colmenaHive = inputs.colmena.lib.makeHive (
      {
        meta = {
          nixpkgs = pkgsCache.x86_64-linux.unstable;
          nodeNixpkgs = lib.mapAttrs (_: cfg: pkgsCache.${cfg.system}.${cfg.channel}) deployableHostConfigs;
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
        imports = cfg.modules ++ [ (nixosSystemParity channels.${cfg.channel}.nixpkgs) ];
      }) deployableHostConfigs
    );
  };
  perSystem =
    { system, ... }:
    {
      _module.args.pkgsSets = pkgsCache.${system};
    };
}
