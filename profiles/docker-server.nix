# profiles/server.nix
{ lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }: 

{
  imports = [
    ../modules/common
    ../modules/services/sshd.nix
    ../modules/apps/docker.nix
    # Even headless servers can have GUI
    ../modules/gui/kdeplasma.nix
    # Tests
    ../tests/check-common.nix
    ../tests/check-docker.nix
    ../tests/check-ssh.nix
    ../tests/check-network.nix
  ];

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;
}