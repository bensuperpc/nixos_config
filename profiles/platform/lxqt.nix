{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Tests
    ../../tests/check-lxqt.nix
  ];

  myConfig.gui.desktop = "lxqt";
  myConfig.gui.extraPackages = true;
}
