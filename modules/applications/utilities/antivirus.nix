{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.antivirus;

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
    scanner = moduleHelpers.mkDisabledOption "Install antivirus scanning tools";
  };

  config = lib.mkMerge [
    {
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
    })
  ];
}

