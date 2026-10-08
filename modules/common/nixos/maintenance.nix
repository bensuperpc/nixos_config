{
  config,
  lib,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.system.nixos;
  autoUpgradeDates = "03:00";
in
{
  options.myConfig.system.nixos = {
    garbageCollector.enable = moduleHelpers.mkEnabledOption "Enable automatic garbage collection for Nix";
    autoUpgrade.enable = moduleHelpers.mkDisabledOption "Enable automatic system upgrades";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.garbageCollector.enable {
      programs.nh.clean = {
        enable = true;
        dates = "daily";
        extraArgs = "--keep 5 --keep-since 30d";
      };
    })
    (lib.mkIf cfg.autoUpgrade.enable {
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
          inherit (config.programs.nh) flake;
          randomizedDelaySec = "45min";
        };
      };
    })
  ];
}
