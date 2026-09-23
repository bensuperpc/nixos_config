{
  config,
  lib,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.system.nixos;
  autoUpgradeDates = [
    "03:00"
  ];
in
{
  options.myConfig.system.nixos = {
    enableGarbageCollector = moduleHelpers.mkEnabledOption "Enable automatic garbage collection for Nix";
    enableAutoUpgrade = moduleHelpers.mkDisabledOption "Enable automatic system upgrades";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enableGarbageCollector {
      programs.nh.clean = {
        enable = true;
        dates = "daily";
        extraArgs = "--keep 5 --keep-since 30d";
      };
    })
    (lib.mkIf cfg.enableAutoUpgrade {
      system = {
        autoUpgrade = {
          enable = true;
          dates = autoUpgradeDates;
          allowReboot = true;
          # rebootWindow = {
          #   lower = "01:00";
          #   upper = "06:00";
          # };
          runGarbageCollection = true;
          persistent = true;
          flake = "github:bensuperpc/nixos_config";
          randomizedDelaySec = "45min";
        };
      };
    })
  ];
}
