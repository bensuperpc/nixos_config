{ inputs, lib, ... }:

name: cfg: 
let
  # All packages and configurations
  mainPkgs = [ ../modules ];

  allProfiles =
    if cfg ? allProfiles then
      cfg.allProfiles
    else
      throw "Host '${name}' is missing 'allProfiles'. Ensure systems/systems.nix is normalized via lib/host-schema.nix.";

  # Import profiles from normalized host schema.
  profilesModules = map (p: ../profiles/${p}.nix) allProfiles;

  # Import user modules
  usersModules = map (u: ../users/${u}/system.nix) (cfg.users or []);
  varsUsers = lib.genAttrs (cfg.users or []) (u: import ../users/${u}/variables.nix);

  # Import variables
  varsSystem = import ../systems/${cfg.systemName}/variables.nix;
  varsHost = {
    name = cfg.systemName;
    role = cfg.role;
    users = cfg.users or [];
    deployUser = cfg.deployUser;
  };

  mkPkgs = input: import input { inherit (cfg) system; config.allowUnfree = true; };
  pkgs-stable   = mkPkgs inputs.nixpkgs-stable;
  pkgs-master   = mkPkgs inputs.nixpkgs-master;
  pkgs-unstable = mkPkgs inputs.nixpkgs-unstable;

  moduleHelpers = import ./options.nix { inherit lib; };
  
  modules = [
    ../systems/${cfg.systemName}/configuration.nix
    #inputs.nixos-hardware.nixosModules.dell-xps-13-9380
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
          inherit pkgs-stable pkgs-master pkgs-unstable moduleHelpers;
          # inherit (moduleHelpers) mkEnabledOption; # Avoid to write moduleHelpers.mkEnabledOption (and {mkEnabledOption, })
        };
      };
      _module.args = {
        inherit varsSystem varsUsers varsHost;
        inherit pkgs-stable pkgs-master pkgs-unstable moduleHelpers;
        # inherit (moduleHelpers) mkEnabledOption; # Avoid to write moduleHelpers.mkEnabledOption (and {mkEnabledOption, })
      };
    }
    inputs.agenix.nixosModules.default
  ] ++ profilesModules ++ usersModules ++ mainPkgs;
in {
  inherit modules moduleHelpers;
  inherit (cfg) system users deployUser;
  ip = cfg.ip or null;
}