# profiles/desktop.nix — desktop-oriented extras: power management and hardware
# tools. Designed to complement kde-plasma.nix.
{ config, lib, pkgs, ... }:
{
  myConfig.apps.powerManagement.services = true;
  myConfig.apps.hardwareGuiTools.tools = true;
  myConfig.apps.hardwareCliTools.tools = true;
}
