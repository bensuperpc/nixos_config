{
  config,
  lib,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.desktop.integration;
in
{
  options.myConfig.apps.desktop = {
    integration.services = moduleHelpers.mkDisabledOption "desktop-oriented apps services (Flatpak, udisks2, gvfs, devmon)";
  };

  config = lib.mkMerge [
    {
      myConfig.apps.desktop.integration.services = lib.mkDefault (config.myConfig.gui.desktop != "none");

      services.logrotate.enable = true;

      programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
    }
    (lib.mkIf cfg.services {
      services = {
        flatpak.enable = true;

        # Enable udisks2 for automounting and managing disks.
        devmon.enable = true;
        udisks2.enable = true;
        gvfs.enable = true;
      };
    })
  ];
}
