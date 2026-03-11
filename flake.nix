{
  description = "Bensuperpc's Multi-Host NixOS configuration";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts/main";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # Hardware support
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager/trunk";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    impermanence = {
      url = "github:nix-community/impermanence/master";
      inputs.nixpkgs.follows = "";
      inputs.home-manager.follows = "";
    };
    disko = {
      url = "github:nix-community/disko/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # For secrets management
    agenix = {
      url = "github:ryantm/agenix/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Deployment tools
    colmena.url = "github:zhaofengli/colmena/main";

    deploy-rs = {
      url = "github:serokell/deploy-rs/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ]; 
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        # 'nix develop'
        devShells.default = pkgs.mkShell {
          name = "nixos-admin-shell";
          
          packages = [
            pkgs.git
            pkgs.colmena
            pkgs.deploy-rs
            inputs'.agenix.packages.default
          ];
          shellHook = ''
          '';
        };
      };

      flake = let
        lib = inputs.nixpkgs.lib;
        
        mkHostConfig = import ./lib/mksystem.nix { inherit inputs lib; };

        hosts = {
          "server-1-m710q" = { systemName = "server-1-m710q"; ip = "192.168.1.27"; profiles = [ "all" ]; users = [ "bensuperpc" ]; system = "x86_64-linux"; };
          "celestia"       = { systemName = "celestia";       ip = "192.168.1.x";  profiles = [ "all" ]; users = [ "bensuperpc" ]; system = "x86_64-linux"; };
          "luna"           = { systemName = "luna";           ip = "192.168.1.x";  profiles = [ "all" ]; users = [ "bensuperpc" ]; system = "x86_64-linux"; };
          "rainbow-dash"   = { systemName = "rainbow-dash";   ip = "192.168.1.x";  profiles = [ "all" ]; users = [ "bensuperpc" ]; system = "x86_64-linux"; };
          "fluttershy"     = { systemName = "fluttershy";     ip = "192.168.1.x";  profiles = [ "docker-server" ]; users = [ "bensuperpc" ]; system = "x86_64-linux"; };
          "pinkie-pie"     = { systemName = "pinkie-pie";     ip = "192.168.1.x";  profiles = [ "all" ]; users = [ "bensuperpc" ]; system = "x86_64-linux"; };
        };

        hostConfigs = lib.mapAttrs mkHostConfig hosts;

        myNixosConfigurations = lib.mapAttrs (name: cfg: lib.nixosSystem {
          inherit (cfg) system;
          specialArgs = { inherit inputs; vars = cfg.hostVars; };
          modules = cfg.modules;
        }) hostConfigs;

      in {
        nixosConfigurations = myNixosConfigurations;

        # Export de Colmena
        colmenaHive = inputs.colmena.lib.makeHive ({
          meta = {
            nixpkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
            specialArgs = { inherit inputs; };
          };
        } // (lib.mapAttrs (name: cfg: {
          deployment = {
            targetHost = cfg.ip;
            targetUser = builtins.elemAt cfg.users 0;
            targetPort = 22;
            buildOnTarget = true;
            allowLocalDeployment = false;
          };
          imports = cfg.modules; 
        }) hostConfigs));

        # Export de Deploy-rs
        deploy.nodes = lib.mapAttrs (name: cfg: {
          hostname = cfg.ip;
          profiles.system = {
            user = "root";
            sshUser = builtins.elemAt cfg.users 0;
            path = inputs.deploy-rs.lib.${cfg.system}.activate.nixos myNixosConfigurations.${name};
          };
        }) hostConfigs;
      };
    };
}