{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.development.benchmark;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      enable = {
        description = "Activate benchmarking and related tools";
        packages = with pkgs; [
          stress-ng
          phoronix-test-suite
          perf
        ];
      };
    };
  };
in
{
  options.myConfig.apps.development.benchmark = generated.options;
  config = generated.config;
}
