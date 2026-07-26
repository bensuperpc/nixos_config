{
  config,
  lib,
  pkgs,
  ...
}:
{
  myConfig.apps = {
    power.management = {
      services = lib.mkDefault true;
      backend = lib.mkDefault "power-profiles-daemon";
    };
    hardware = {
      gui.tools = lib.mkDefault true;
      cli.tools = lib.mkDefault true;
    };
  };
}
