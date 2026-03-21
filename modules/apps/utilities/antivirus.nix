{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  cfg = config.myConfig.apps.antivirus;

  basePackages = with pkgs; [ ];

  scannerPackages = with pkgs; [
    clamtk
  ];

  enabledOptionalsPackages =
    lib.optionals cfg.scanner scannerPackages;

  anyEnabled = lib.any (x: x) [
    cfg.scanner
  ];
in
{
  options.myConfig.apps.antivirus = {
    scanner = moduleHelpers.mkEnabledOption "Install antivirus scanning tools";
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

