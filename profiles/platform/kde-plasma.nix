{ config, lib, pkgs, ... }:

{
  imports = [
    # Tests
    ../../tests/check-network.nix
    ../../tests/check-tools.nix
    ../../tests/check-terminal.nix
  ];

  myConfig.apps.gui.kdeplasma.enable = true;
  myConfig.apps.gui.kdeplasma.extraPackages = true;
}