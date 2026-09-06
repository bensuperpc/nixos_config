{
  inputs,
  lib,
  pkgsCache,
  moduleHelpers,
  ...
}:

name: cfg:
let
  # All packages and configurations
  mainPkgs = [ ../modules ];

  requirePath =
    what: path:
    if builtins.pathExists path then
      path
    else
      throw "Host '${name}' is missing ${what}: ${toString path}";

  allProfiles =
    cfg.allProfiles
      or (throw "Host '${name}' is missing 'allProfiles'. Ensure systems/systems.nix is normalized via lib/host-schema.nix.");

  # Import profiles from normalized host schema.
  profilesModules = map (p: requirePath "profile" ../profiles/${p}.nix) allProfiles;

  varsUsers = lib.genAttrs (cfg.users or [ ]) (
    u: import (requirePath "user variables" ../users/${u}/variables.nix)
  );

  # Wrap each user module to inject its own variables as a NixOS module argument.
  usersModules = map (u: {
    _module.args.userVars = varsUsers.${u};
    imports = [ (requirePath "user system module" ../users/${u}/system.nix) ];
  }) (cfg.users or [ ]);

  varsHost = {
    name = cfg.systemName;
    inherit (cfg) role;
    inherit (cfg) enabled;
    inherit (cfg) users;
    inherit (cfg) deployUser;
    inherit (cfg) ip;
    inherit (cfg) port;
  };

  pkgsSets =
    if builtins.hasAttr cfg.system pkgsCache then
      pkgsCache.${cfg.system}
    else
      throw "Unsupported system '${cfg.system}' for host '${name}'.";

  modules = [
    (requirePath "system configuration" ../systems/${cfg.systemName}/configuration.nix)
    # inputs.nixos-hardware.nixosModules.dell-xps-13-9380
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModules.impermanence
    inputs.disko.nixosModules.disko
    inputs.agenix.nixosModules.default
    inputs.nixos-wsl.nixosModules.wsl
    inputs.nix-ld.nixosModules.nix-ld
    inputs.lanzaboote.nixosModules.lanzaboote
    ({ config, ... }: {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        sharedModules = [ inputs.plasma-manager.homeModules.plasma-manager ];
        extraSpecialArgs = {
          inherit inputs;
          inherit pkgsSets moduleHelpers;
          inherit varsHost;
        };
      };
      _module.args = {
        inherit varsUsers;
        inherit pkgsSets moduleHelpers;
        inherit varsHost;
      };
    })
  ]
  ++ profilesModules
  ++ usersModules
  ++ mainPkgs;
in
{
  inherit modules;
  host = varsHost;
  inherit (cfg) system users;
}
