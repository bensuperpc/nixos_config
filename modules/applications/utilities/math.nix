{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.math;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      geometry = {
        description = "Install geometry and interactive math tools";
        packages = with pkgs; [ geogebra ];
      };
      plotting = {
        description = "Install mathematical plotting and graphing tools";
        packages = with pkgs; [
          mathgl
          mathmod
        ];
      };
    };
  };
in
{
  options.myConfig.apps.math = generated.options;
  config = generated.config;
}
