{
  config,
  lib,
  pkgs,
  pkgsSets,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.printing3d;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      tools = {
        description = "Install 3D printing tools";
        packages = with pkgs; [
          prusa-slicer
          klipper
          orca-slicer
          # cura
          # curaengine
        ];
      };
    };
  };
in
{
  options.myConfig.apps.printing3d = generated.options;
  config = generated.config;
}
