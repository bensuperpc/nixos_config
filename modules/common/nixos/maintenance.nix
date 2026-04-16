{ config, lib, moduleHelpers, ... }:

let
  cfg = config.myConfig.system.nixos;
  garbageCollectorDates = [
    "03:00"
    "15:00"
  ];
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
      nix = {
        gc = {
          automatic = true;
          persistent = true;
          randomizedDelaySec = "30min";
          dates = garbageCollectorDates;
          options = "--delete-older-than 30d";
        };
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
          flake = "github:bensuperpc/nix_config";
          randomizedDelaySec = "45min";
        };
      };
    })
  ];
}