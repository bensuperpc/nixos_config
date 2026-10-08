{
  config,
  lib,
  moduleHelpers,
  varsHost,
  ...
}:

let
  cfg = config.myConfig.system.snapper;
in
{
  options.myConfig.system.snapper.enable =
    moduleHelpers.mkDisabledOption "Snapper for managing snapshots";

  config = lib.mkIf cfg.enable {
    services.snapper = {
      snapshotInterval = "hourly";
      cleanupInterval = "1d";

      configs = {
        home = {
          SUBVOLUME = "/home";
          BACKGROUND_COMPARISON = "yes";

          TIMELINE_CREATE = true;
          TIMELINE_CLEANUP = true;

          TIMELINE_LIMIT_HOURLY = "12";
          TIMELINE_LIMIT_DAILY = "7";
          TIMELINE_LIMIT_WEEKLY = "4";
          TIMELINE_LIMIT_MONTHLY = "6";
          TIMELINE_LIMIT_YEARLY = "0";
          NUMBER_LIMIT = "20";
          SPACE_LIMIT = "0.2";
          NUMBER_LIMIT_IMPORTANT = "10";
          NUMBER_MIN_AGE = "60";

          ALLOW_USERS = [ varsHost.deployUser ];
          SYNC_ACL = true;
          ALLOW_GROUPS = [
            "wheel"
          ];
        };
      };
    };
  };
}
