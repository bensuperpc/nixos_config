{
  config,
  lib,
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
        description = "Activate VS Code and IDE tooling";
        packages = with pkgs; [
          vscode
          pragtical
        ];
      };
    };
  };
in
{
  options.myConfig.apps.development.ide = generated.options;
  config = generated.config;
}
