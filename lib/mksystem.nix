{ inputs, lib, ... }:

name: cfg: 
let
  # All packages and configurations
  mainPkgs = [ ../modules ];

  # Import profiles
  profilesModules = map (p: ../profiles/${p}.nix) (cfg.profiles or []);

  # Import user modules
  usersModules = map (u: ../users/${u}/system.nix) (cfg.users or []);
  usersVars = map (u: import ../users/${u}/variables.nix) (cfg.users or []);

  # Import variables
  globalVars = import ../variables/default.nix;
  systemVars = import ../systems/${cfg.systemName}/variables.nix;

  pkgs-stable = import inputs.nixpkgs-stable {
    inherit (cfg) system;
    config.allowUnfree = true;
  };
  pkgs-master = import inputs.nixpkgs-master {
    inherit (cfg) system;
    config.allowUnfree = true;
  };
  pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit (cfg) system;
    config.allowUnfree = true;
  };
  moduleHelpers = import ./options.nix { inherit lib; };
  
  # Merge all variables together, with the following precedence: global < system < users
  hostVars = lib.foldl' (acc: vars: lib.recursiveUpdate acc vars) {} ([globalVars systemVars] ++ usersVars);

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
          vars = hostVars;
          inherit pkgs-stable pkgs-master pkgs-unstable moduleHelpers;
          # inherit (moduleHelpers) mkEnabledOption; # Avoid to write moduleHelpers.mkEnabledOption (and {mkEnabledOption, })
        };
      };
      _module.args = {
        vars = hostVars;
        inherit pkgs-stable pkgs-master pkgs-unstable moduleHelpers;
        # inherit (moduleHelpers) mkEnabledOption; # Avoid to write moduleHelpers.mkEnabledOption (and {mkEnabledOption, })
      };
    }
    inputs.agenix.nixosModules.default
  ] ++ profilesModules ++ usersModules ++ mainPkgs;
in {
  inherit modules hostVars moduleHelpers;
  inherit (cfg) system ip users; 
}