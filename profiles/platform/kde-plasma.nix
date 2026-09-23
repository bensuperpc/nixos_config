{ lib, ... }:
{
  myConfig.gui = {
    desktop = "plasma";
    extraPackages = lib.mkDefault true;
  };
}
