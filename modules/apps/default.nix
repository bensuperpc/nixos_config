{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:
{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  imports = [
    ./multimedia
    ./development
    ./games
    ./docker
    ./files
    ./system
    ./network
    ./desktop
    ./utilities
  ];

  environment.systemPackages = [
    (pkgs.callPackage ./custom/lib/bs-thread-pool.nix { })
    (pkgs.callPackage ./custom/lib/fake-function-framework.nix { })
  ];

  # nixpkgs.overlays = [
  #   (final: prev: {
  #     lager = prev.lager.override {
  #       boost = pkgs-stable.boost;
  #     };
  #     gource = prev.gource.override {
  #       boost = pkgs-stable.boost;
  #     };
  #   })
  # ];
}