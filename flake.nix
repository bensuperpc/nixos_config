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
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
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
      systems = [ "x86_64-linux" "aarch64-linux" ]; 
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        # nix develop .#python2-shell to enter to python2-shell devshell
        devShells = import ./devshells {
          inherit pkgs inputs';
        };
      };

      flake = let
        lib = inputs.nixpkgs.lib;
        moduleHelpers = import ./lib/options.nix { inherit lib; };

        mkHostConfig = import ./lib/mksystem.nix { inherit inputs lib; };
        hosts = import ./systems/systems.nix { inherit lib; };

        hostConfigs = lib.mapAttrs mkHostConfig hosts;
        deployableHostConfigs = lib.filterAttrs (_: cfg: cfg.ip != null) hostConfigs;

        myNixosConfigurations = lib.mapAttrs (name: cfg: lib.nixosSystem {
          inherit (cfg) system;
          specialArgs = {
            inherit inputs;
            moduleHelpers = cfg.moduleHelpers;
          };
          modules = cfg.modules;
        }) hostConfigs;

      in {
        nixosConfigurations = myNixosConfigurations;

        # Export de Colmena
        colmenaHive = inputs.colmena.lib.makeHive ({
          meta = {
            nixpkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
            specialArgs = {
              inherit inputs moduleHelpers;
            };
          };
        } // (lib.mapAttrs (name: cfg: {
          deployment = {
            targetHost = cfg.ip;
            targetUser = cfg.deployUser;
            targetPort = 22;
            buildOnTarget = true;
            allowLocalDeployment = false;
          };
          imports = cfg.modules; 
        }) deployableHostConfigs));

        # Export de Deploy-rs
        deploy.nodes = lib.mapAttrs (name: cfg: {
          hostname = cfg.ip;
          profiles.system = {
            user = "root";
            sshUser = cfg.deployUser;
            path = inputs.deploy-rs.lib.${cfg.system}.activate.nixos myNixosConfigurations.${name};
          };
        }) deployableHostConfigs;
      };
    };
}