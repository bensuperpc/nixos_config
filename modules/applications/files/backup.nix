{ config, lib, pkgs, pkgs-stable, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.files.backup;

  corePackages = with pkgs; [
    restic
    rustic
  ];
  profileManagerPackages = with pkgs; [
    pkgs-stable.resticprofile
  ];
  guiPackages = with pkgs; [
    restic-browser
  ];

  enabledOptionalsPackages =
    lib.optionals cfg.core corePackages
    ++ lib.optionals cfg.profileManager profileManagerPackages
    ++ lib.optionals cfg.gui guiPackages;

  anyEnabled = lib.any (x: x) [
    cfg.core
    cfg.profileManager
    cfg.gui
  ];
in
{
  options.myConfig.apps.files.backup = {
    core = moduleHelpers.mkDisabledOption "Install core backup tools";
    profileManager = moduleHelpers.mkDisabledOption "Install backup profile manager";
    gui = moduleHelpers.mkDisabledOption "Install backup graphical interface";
  };

  config = lib.mkMerge [
    {
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
    })
  ];
}
