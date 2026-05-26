{ config, lib, pkgs, ... }:
{
  myConfig.apps.power.management.services = true;
  myConfig.apps.power.management.backend  = "power-profiles-daemon";
  myConfig.apps.hardware.gui.tools = true;
  myConfig.apps.hardware.cli.tools = true;
}
