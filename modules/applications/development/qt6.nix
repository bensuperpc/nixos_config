{
  config,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.development.qt6;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      qtcreator = {
        description = "Install Qt Creator IDE";
        packages = with pkgs; [ qtcreator ];
      };
    };
  };
in
{
  options.myConfig.apps.development.qt6 = generated.options;
  inherit (generated) config;
}
