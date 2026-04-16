{ inputs, lib, pkgsCache, moduleHelpers, ... }:

name: cfg: 
let
  # All packages and configurations
  mainPkgs = [ ../modules ];

  requirePath = what: path:
    if builtins.pathExists path then
      path
    else
      throw "Host '${name}' is missing ${what}: ${toString path}";

  allProfiles =
    if cfg ? allProfiles then
      cfg.allProfiles
    else
      throw "Host '${name}' is missing 'allProfiles'. Ensure systems/systems.nix is normalized via lib/host-schema.nix.";

  # Import profiles from normalized host schema.
  profilesModules = map (p: requirePath "profile" ../profiles/${p}.nix) allProfiles;

  # Import user modules
  usersModules = map (u: requirePath "user system module" ../users/${u}/system.nix) (cfg.users or []);
  varsUsers = lib.genAttrs (cfg.users or []) (u: import (requirePath "user variables" ../users/${u}/variables.nix));

  # Import and merge variables (global defaults overridden by host-specific values).
  varsSystemGlobals = import ../systems/global-variables.nix;
  varsSystemRaw = import (requirePath "system variables" ../systems/${cfg.systemName}/variables.nix);
  varsSystem = lib.recursiveUpdate varsSystemGlobals varsSystemRaw;
  varsHost = {
    name = cfg.systemName;
    role = cfg.role;
    enabled = cfg.enabled;
    users = cfg.users;
    deployUser = cfg.deployUser;
    ip = cfg.ip;
    port = cfg.port;
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
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        sharedModules = [ inputs.plasma-manager.homeModules.plasma-manager ];
        extraSpecialArgs = {
          inherit inputs;
          inherit pkgsSets moduleHelpers;
          # inherit (moduleHelpers) mkEnabledOption; # Avoid to write moduleHelpers.mkEnabledOption (and {mkEnabledOption, })
        };
      };
      _module.args = {
        inherit varsSystem varsUsers varsHost;
        inherit pkgsSets moduleHelpers;
        # inherit (moduleHelpers) mkEnabledOption; # Avoid to write moduleHelpers.mkEnabledOption (and {mkEnabledOption, })
      };
    }
    inputs.agenix.nixosModules.default
    inputs.nixos-wsl.nixosModules.wsl
  ] ++ profilesModules ++ usersModules ++ mainPkgs;
in {
  inherit modules;
  host = varsHost;
  inherit (cfg) system users;
}