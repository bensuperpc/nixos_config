{
  config,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.development.ide;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      enable = {
        description = "Activate IDE tooling";
        packages = with pkgs; [
          pragtical
          vscode
        ];
      };
    };
  };
in
{
  options.myConfig.apps.development.ide = generated.options;
  inherit (generated) config;
}
