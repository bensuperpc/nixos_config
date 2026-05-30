{ config, lib, pkgs, ... }:
{
  myConfig.apps.power.management.services = lib.mkDefault true;
  myConfig.apps.power.management.backend  = lib.mkDefault "power-profiles-daemon";
  myConfig.apps.hardware.gui.tools = lib.mkDefault true;
  myConfig.apps.hardware.cli.tools = lib.mkDefault true;
}
