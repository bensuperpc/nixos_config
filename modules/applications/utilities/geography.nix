{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.geography;

  geographyPackages = with pkgs; [
    qgis
  ];

  enabledOptionalsPackages = lib.optionals cfg.viewer geographyPackages;

  anyEnabled = cfg.viewer;
in
{
  options.myConfig.apps.geography = {
    viewer = moduleHelpers.mkDisabledOption "Install geography packages (e.g., QGIS)";
  };

  config = lib.mkIf anyEnabled {
    environment.systemPackages = enabledOptionalsPackages;
  };
}
