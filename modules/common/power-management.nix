{ config, lib, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.power.management;
  enabledBackends = builtins.length (lib.filter (x: x) [
    cfg.powerProfilesDaemon
    cfg.tuned
    cfg.tlp
  ]);
in
{
  options.myConfig.apps.power.management = {
    services = moduleHelpers.mkEnabledOption "power management services for desktop/laptop machines";

    powerProfilesDaemon = moduleHelpers.mkEnabledOption "Enable power-profiles-daemon as the active power manager.";
    tuned = moduleHelpers.mkDisabledOption "Enable tuned as the active power manager.";
    tlp = moduleHelpers.mkDisabledOption "Enable TLP as the active power manager.";
  };

  config = lib.mkMerge [
    {
      assertions = [
        {
          assertion = !(cfg.services && enabledBackends > 1);
          message = "Only one power management backend can be enabled at a time: myConfig.apps.power.management.powerProfilesDaemon, myConfig.apps.power.management.tuned, or myConfig.apps.power.management.tlp.";
        }
        {
          assertion = !(cfg.services && enabledBackends == 0);
          message = "You must enable one power management backend if myConfig.apps.power.management.services is enabled: myConfig.apps.power.management.powerProfilesDaemon, myConfig.apps.power.management.tuned, or myConfig.apps.power.management.tlp.";
        }
      ];
    }

    (lib.mkIf cfg.services {
      services.power-profiles-daemon.enable = cfg.powerProfilesDaemon;
      services.tuned.enable = cfg.tuned;
      services.tlp.enable = cfg.tlp;
    })
  ];
}