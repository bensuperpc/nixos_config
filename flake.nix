{
  description = "Bensuperpc's Multi-Host NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    colmena.url = "github:zhaofengli/colmena/main";
    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs = { self, nixpkgs, colmena, deploy-rs, ... }@inputs:
    let
      lib = nixpkgs.lib;
      
      mkHostConfig = import ./lib/mksystem.nix { inherit inputs lib; };

      hosts = {
        # NioxOS test server
        "server-1-m710q" = { 
          name = "server-1-m710q";
          ip = "192.168.1.26";
          user = "bensuperpc";
          system = "x86_64-linux"; 
        };
        # # Main PC
        # "celestia" = {
        #   name = "celestia";
        #   ip = "192.168.1.x";
        #   user = "bensuperpc";
        #   system = "x86_64-linux"; 
        # };
        # # Secondary PC
        # "luna" = {
        #   name = "luna";
        #   ip = "192.168.1.x";
        #   user = "bensuperpc";
        #   system = "x86_64-linux"; 
        # };
        # # Main Laptop
        # "rainbow-dash" = {
        #   name = "rainbow-dash";
        #   ip = "192.168.1.x";
        #   user = "bensuperpc";
        #   system = "x86_64-linux"; 
        # };
        # # Web server 1
        # "fluttershy" = {
        #   name = "fluttershy";
        #   ip = "192.168.1.x";
        #   user = "bensuperpc";
        #   system = "x86_64-linux"; 
        # };
        # # Game server 1
        # "pinkie-pie" = {
        #   name = "pinkie-pie";
        #   ip = "192.168.1.x";
        #   user = "bensuperpc";
        #   system = "x86_64-linux"; 
        # };
      };

      hostConfigs = lib.mapAttrs mkHostConfig hosts;

    in {
      # NixOS Configurations
      nixosConfigurations = lib.mapAttrs (name: cfg: lib.nixosSystem {
        inherit (cfg) system;
        specialArgs = { inherit inputs; vars = cfg.hostVars; };
        modules = cfg.modules;
      }) hostConfigs;

      # Colmena
      colmenaHive = colmena.lib.makeHive ({
        meta = {
          nixpkgs = import nixpkgs { system = "x86_64-linux"; };
          specialArgs = { inherit inputs; };
        };
      } // (lib.mapAttrs (name: cfg: {
        deployment = { 
          targetHost = cfg.ip; 
          targetUser = cfg.user; 
          buildOnTarget = true; 
        };
        imports = cfg.modules;
      }) hostConfigs));

      # Deploy-rs
      deploy.nodes = lib.mapAttrs (name: cfg: {
        hostname = cfg.ip;
        profiles.system = {
          user = "root";
          sshUser = cfg.user;
          path = deploy-rs.lib.${cfg.system}.activate.nixos self.nixosConfigurations.${name};
        };
      }) hostConfigs;
    };
}