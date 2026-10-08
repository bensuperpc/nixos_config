{ moduleHelpers, ... }:
{
  myConfig = moduleHelpers.mkDefaults {
    system.power.management = {
      enable = true;
      backend = "power-profiles-daemon";
    };

    apps.utilities.hardware = {
      gui = true;
      cli = true;
    };
  };
}
