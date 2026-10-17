{
  config,
  pkgs,
  pkgsSets,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.utilities.math;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      geometry = {
        description = "Install geometry and interactive math tools";
        packages = with pkgs; [ geogebra ];
      };
      plotting = {
        description = "Install mathematical plotting and graphing tools";
        packages = [
          pkgs.mathgl
          pkgsSets.stable-2605.mathmod # Broken with GCC 16 on unstable
        ];
      };
    };
  };
in
{
  options.myConfig.apps.utilities.math = generated.options;
  inherit (generated) config;
}
