# profiles/all.nix
{ lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }: 
{
  imports = [
    ../modules/default.nix
    # Tests
    ../tests/check-common.nix
    ../tests/check-docker.nix
    ../tests/check-ssh.nix
    ../tests/check-video.nix
    ../tests/check-image.nix
    ../tests/check-dev.nix
    ../tests/check-network.nix
    ../tests/check-browser.nix
  ];

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;
}