{ lib, ... }:
{
  myConfig.gui = {
    desktop = "lxqt";
    extraPackages = lib.mkDefault true;
  };
}
