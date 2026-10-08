{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.myConfig.gui;
in
{
  config = lib.mkIf (cfg.desktop == "lxqt") {
    myConfig.system.impermanence.persistDirectories = [ "/var/lib/sddm" ];

    services = {
      xserver = {
        enable = true;
        desktopManager.lxqt.enable = true;
      };

      displayManager.sddm.enable = true;
    };

    environment.systemPackages = with pkgs; [
      xdg-utils
      flatpak-xdg-utils
    ];
  };
}
