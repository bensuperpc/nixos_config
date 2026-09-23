{
  inputs,
  lib,
  pkgsCache,
}:

name: cfg:
let
  requirePath =
    what: path:
    if builtins.pathExists path then
      path
    else
      throw "Host '${name}' is missing ${what}: ${toString path}";

  # Import profiles from normalized host schema.
  profilesModules = map (p: requirePath "profile" ../profiles/${p}.nix) cfg.allProfiles;

  # Variables of every user of the host, keyed by user name.
  varsUsers = lib.genAttrs cfg.users (
    u: import (requirePath "user variables" ../users/${u}/variables.nix)
  );

  # Wrap each user module to inject its own variables as a NixOS module argument.
  usersModules = map (u: {
    _module.args.userVars = varsUsers.${u};
    imports = [ (requirePath "user system module" ../users/${u}/system.nix) ];
  }) cfg.users;

  varsHost = {
    name = cfg.systemName;
    inherit (cfg)
      role
      users
      deployUser
      ip
      port
      ageRecipient
      ;
  };

  pkgsSets =
    pkgsCache.${cfg.system} or (throw "Unsupported system '${cfg.system}' for host '${name}'.");

  modules = [
    (requirePath "system configuration" ../systems/${cfg.systemName}/configuration.nix)
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModules.impermanence
    inputs.disko.nixosModules.disko
    inputs.sops-nix.nixosModules.sops
    inputs.nixos-wsl.nixosModules.wsl
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.microvm.nixosModules.host
    inputs.nix-flatpak.nixosModules.nix-flatpak
    inputs.nix-index-database.nixosModules.nix-index
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        sharedModules = [
          inputs.plasma-manager.homeModules.plasma-manager
          inputs.nix-flatpak.homeManagerModules.nix-flatpak
        ];
        extraSpecialArgs = { inherit inputs pkgsSets varsHost; };
      };
      _module.args = { inherit pkgsSets varsHost varsUsers; };
    }
    ../modules
  ]
  ++ profilesModules
  ++ usersModules;
in
{
  inherit modules;
  host = varsHost;
  inherit (cfg) system;
}
