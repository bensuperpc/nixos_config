{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.development.databases;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      relational = {
        description = "Install relational database servers and tooling";
        packages = with pkgs; [
          sqlite
          postgresql
          mariadb
        ];
      };
      kv = {
        description = "Install key-value database tooling";
        packages = with pkgs; [ valkey ];
      };
    };
  };
in
{
  options.myConfig.apps.development.databases = generated.options;
  inherit (generated) config;
}
