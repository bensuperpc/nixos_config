{ config, lib, pkgs, ... }:

let
  cfg = config.myConfig.gui;
in {
  config = lib.mkIf (cfg.desktop == "lxqt") {
    services.xserver.enable = true;
    services.xserver.desktopManager.lxqt.enable = true;

    services.displayManager.sddm.enable = true;

    environment.systemPackages = with pkgs; lib.optionals (cfg.desktop == "lxqt" && cfg.extraPackages)
    [
      xdg-utils
      flatpak-xdg-utils
    ];
  };
}
