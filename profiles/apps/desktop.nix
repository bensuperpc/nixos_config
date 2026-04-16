# profiles/desktop.nix — desktop-oriented extras: power management and hardware
# tools. Designed to complement kde-plasma.nix.
{ config, lib, pkgs, ... }:
{
  myConfig.apps.power.management.services = true;
  myConfig.apps.power.management.powerProfilesDaemon = true;
  myConfig.apps.hardware.gui.tools = true;
  myConfig.apps.hardware.cli.tools = true;
}
