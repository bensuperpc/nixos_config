{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

{
  imports = [
    ../tests/check-common.nix
    ../tests/check-ssh.nix
    ../tests/check-network.nix
    ../tests/check-tools.nix
  ];

  # Essential CLI and system foundations shared by all profiles.
  myConfig.apps.ssh.enable = true;
  myConfig.apps.compress = {
    base = true;
    tools = true;
  };
  myConfig.apps.networkingTools.tooling = true;
  myConfig.apps.terminal.enable = true;
  #myConfig.apps.tools.enable = true;

  myConfig.apps.gui.kdeplasma.enable = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;
}