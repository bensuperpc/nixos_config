{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  cfg = config.myConfig.apps.files.backup;
  basePackages = with pkgs; [ ];
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
    core = moduleHelpers.mkEnabledOption "Install core backup tools";
    profileManager = moduleHelpers.mkEnabledOption "Install backup profile manager";
    gui = moduleHelpers.mkEnabledOption "Install backup graphical interface";
  };

  config = lib.mkMerge [
    {
      environment.systemPackages = basePackages;
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
    })
  ];
}
