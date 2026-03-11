{ pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:
{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  imports = [
    ./multimedia
    ./development
    ./games
    ./docker
    ./kvm.nix
    ./compress.nix
    ./office.nix
    ./tools.nix
    ./browser.nix
    ./files.nix
    ./math.nix
    ./filesystem.nix
    ./hardware.nix
    ./terminal.nix
    ./flashing.nix
  ];
  # ./ollama.nix

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