{
  config,
  lib,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.system.diskHealth;
  rootIsBtrfs = (config.fileSystems."/".fsType or "") == "btrfs";
in
{
  options.myConfig.system.diskHealth = {
    enable = moduleHelpers.mkEnabledOption "SMART monitoring (smartd) and monthly btrfs scrub";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        services.smartd = {
          enable = true;
          notifications.systembus-notify.enable = config.services.earlyoom.enableNotifications;
        };
        systemd.services.smartd.unitConfig.ConditionVirtualization = "no";
      }
      (lib.mkIf rootIsBtrfs {
        myConfig.system.impermanence.persistDirectories = [ "/var/lib/btrfs" ];

        services.btrfs.autoScrub = {
          enable = true;
          interval = "monthly";
          fileSystems = [ "/" ];
        };
      })
    ]
  );
}
