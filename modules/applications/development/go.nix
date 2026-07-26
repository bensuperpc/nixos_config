{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.development.go;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      toolchain = {
        description = "Install Go toolchain";
        packages = with pkgs; [ go ];
      };
    };
  };
in
{
  options.myConfig.apps.development.go = generated.options;
  inherit (generated) config;
}
