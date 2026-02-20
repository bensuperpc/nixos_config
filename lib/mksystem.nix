{ inputs, lib, ... }:

name: cfg: 
let
  globalVars = import ../vars/default.nix;
  
  #safeImport = path: if builtins.pathExists path then import path else {};
  
  hostVars = globalVars 
             // (import ../systems/${cfg.name}/vars.nix) 
             // (import ../users/${cfg.user}/vars.nix);

  modules = [
    ../systems/${cfg.name}/configuration.nix
    ../users/${cfg.user}/user.nix
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        sharedModules = [ inputs.plasma-manager.homeModules.plasma-manager ];
        extraSpecialArgs = { inherit inputs; vars = hostVars; };
      };
      _module.args.vars = hostVars;
    }
  ];
in {
  inherit modules hostVars;
  inherit (cfg) system ip user;
}