{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  cfg = config.myConfig.apps.development.bdd;
  basePackages = with pkgs; [ ];
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
    relational = moduleHelpers.mkEnabledOption "Install relational database servers and tooling";

    kv = moduleHelpers.mkEnabledOption "Install key-value database tooling";
  };

  config = lib.mkMerge [
    {
      environment.systemPackages = basePackages;
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
    })
  ];
}