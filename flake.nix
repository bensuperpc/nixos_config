{
  description = "Bensuperpc's Multi-Host NixOS configuration";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-2605.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-2511.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-2505.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs.follows = "nixpkgs-2605";

    flake-parts = {
      url = "github:hercules-ci/flake-parts/main";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    # lanzaboote = {
    #   url = "github:nix-community/lanzaboote/master";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # Hardware support
    # nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
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

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    # For secrets management
    agenix = {
      url = "github:ryantm/agenix/main";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # WSL support
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
    };

    # Deployment tools
    colmena = {
      url = "github:zhaofengli/colmena/main";
      inputs.flake-compat.follows = "flake-compat";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs/master";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
    };
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ./flake-module.nix ];
      systems = [ "x86_64-linux" "aarch64-linux" ];
      perSystem = { pkgs, inputs', ... }: {
        # nix develop .#python314 to enter the Python 3.14 devshell
        devShells = import ./devshells { inherit pkgs inputs'; };

        # nix fmt
        formatter = pkgs.nixfmt;
      };
    };
}