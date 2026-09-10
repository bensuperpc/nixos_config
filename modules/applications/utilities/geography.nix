{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.utilities.geography;

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
  options.myConfig.apps.utilities.geography = generated.options;
  inherit (generated) config;
}
