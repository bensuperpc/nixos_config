{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.antivirus;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      scanner = {
        description = "Install antivirus scanning tools";
        packages = with pkgs; [ clamtk ];
      };
    };
  };
in
{
  options.myConfig.apps.antivirus = generated.options;
  config = generated.config;
}
