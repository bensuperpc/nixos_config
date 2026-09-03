{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.geography;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      viewer = {
        description = "Install geography packages (e.g., QGIS)";
        packages = with pkgs; [ qgis ];
      };
    };
  };
in
{
  options.myConfig.apps.geography = generated.options;
  config = generated.config;
}
