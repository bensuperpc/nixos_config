{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Tests
    ../../tests/check-gui.nix
  ];

  config.myConfig.gui.desktop = "plasma";
  config.myConfig.gui.extraPackages = true;
}
