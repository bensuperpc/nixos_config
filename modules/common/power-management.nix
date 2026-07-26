{
  config,
  lib,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.power.management;
in
{
  options.myConfig.apps.power.management = {
    services = moduleHelpers.mkDisabledOption "power management services for desktop/laptop machines";

    backend = lib.mkOption {
      type = lib.types.enum [
        "power-profiles-daemon"
        "tuned"
        "tlp"
      ];
      default = "power-profiles-daemon";
      description = "Power management backend to use when services is enabled.";
    };
  };

  config = lib.mkIf cfg.services {
    services = {
      power-profiles-daemon.enable = cfg.backend == "power-profiles-daemon";
      tuned.enable = cfg.backend == "tuned";
      tlp.enable = cfg.backend == "tlp";
    };
  };
}
