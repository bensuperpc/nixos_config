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
    integration.enable = moduleHelpers.mkBoolOption (
      config.myConfig.gui.desktop != "none"
    ) "desktop-oriented services (udisks2, gvfs, devmon), on by default with a desktop environment";
  };

  config = lib.mkMerge [
    {
      programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
    }
    (lib.mkIf cfg.enable {
      services = {
        # Enable udisks2 for automounting and managing disks.
        devmon.enable = true;
        udisks2.enable = true;
        gvfs.enable = true;
      };
    })
  ];
}
