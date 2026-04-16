{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.development.bdd;


  relationalPackages = with pkgs; [
    sqlite
    postgresql
    mariadb
  ];
  kvPackages = with pkgs; [
    valkey
  ];

  enabledOptionalsPackages =
    lib.optionals cfg.relational relationalPackages
    ++ lib.optionals cfg.kv kvPackages;

  anyEnabled = lib.any (x: x) [
    cfg.relational
    cfg.kv
  ];
in
{
  options.myConfig.apps.development.bdd = {
    relational = moduleHelpers.mkDisabledOption "Install relational database servers and tooling";

    kv = moduleHelpers.mkDisabledOption "Install key-value database tooling";
  };

  config = lib.mkMerge [
    {
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
    })
  ];
}