{
  config,
  lib,
  pkgs,
  ...
}:
{
  myConfig.system.power.management = {
    services = lib.mkDefault true;
    backend = lib.mkDefault "power-profiles-daemon";
  };

  myConfig.apps.utilities.hardware = {
    gui.tools = lib.mkDefault true;
    cli.tools = lib.mkDefault true;
  };
}
