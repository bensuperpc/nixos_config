{ config, lib, pkgs, ... }:

{
  imports = [
    # Tests
    ../../tests/check-gui.nix
  ];

  myConfig.gui.desktop = "plasma";
  myConfig.gui.extraPackages = true;
}