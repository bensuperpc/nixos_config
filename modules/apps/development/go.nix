{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  cfg = config.myConfig.apps.development.go;

  basePackages = with pkgs; [ ];

  goPackages = with pkgs; [
    go
  ];

  enabledOptionalsPackages =
    lib.optionals cfg.toolchain goPackages;

  anyEnabled = lib.any (x: x) [
    cfg.toolchain
  ];
in
{
  options.myConfig.apps.development.go = {
    toolchain = moduleHelpers.mkEnabledOption "Install Go toolchain";
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