{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.development.go;

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
    toolchain = moduleHelpers.mkDisabledOption "Install Go toolchain";
  };

  config = lib.mkMerge [
    {
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
    })
  ];
}