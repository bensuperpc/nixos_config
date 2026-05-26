{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.desktop.integration;
in {

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
      services.flatpak.enable = true;

      # Enable udisks2 for automounting and managing disks.
      services.devmon.enable = true;
      services.udisks2.enable = true;
      services.gvfs.enable = true;
    })
  ];

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  # services.tlp.enable = true;

  # services.restic.backups = {
  #   home = {
  #     initialize = true;
  #     user = "restic";
  #     paths = [ "/home" ];
  #     repository = "";
  #     timerConfig = {
  #       onCalendar = "00:05";
  #       Persistent = true;
  #       RandomizedDelaySec = "1h";
  #     };
  #     passwordFile = "";
  #   };
  # };

}