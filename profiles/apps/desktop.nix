{
  lib,
  ...
}:
{
  myConfig.system.power.management = {
    enable = lib.mkDefault true;
    backend = lib.mkDefault "power-profiles-daemon";
  };

  myConfig.apps.utilities.hardware = {
    gui = lib.mkDefault true;
    cli = lib.mkDefault true;
  };
}
