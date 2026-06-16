{ config, lib, pkgs, ... }:
{
  imports = [
  ];
  myConfig.apps.development.qt6 = {
    base = lib.mkDefault true;
    qtcreator = lib.mkDefault true;
  };
}
