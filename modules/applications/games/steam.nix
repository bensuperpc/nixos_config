{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.games.steam;

  performancePackages = with pkgs; [
    mangohud
  ];

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      client = {
        description = "Install and configure Steam client";
        packages = with pkgs; [ steam-run ];
      };
      performanceTools = {
        description = "Install MangoHud and GameMode";
        packages = performancePackages;
      };
      protonGE = {
        description = "Install ProtonGE (registered in Steam) and Wine tooling";
        packages = with pkgs; [
          protonup-qt
          wineWow64Packages.waylandFull
          vkd3d
        ];
      };
    };
  };
in
{
  options.myConfig.apps.games.steam = generated.options // {
    ntsync = moduleHelpers.mkDisabledOption "Load the ntsync kernel module for improved input latency in games";
  };

  config = lib.mkMerge [
    generated.config

    (lib.mkIf cfg.client {
      programs.steam = {
        enable = true;
        protontricks.enable = true;
        remotePlay.openFirewall = true;
        #dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;

        extraPackages = lib.optionals cfg.performanceTools performancePackages;
        extraCompatPackages = lib.optionals cfg.protonGE [ pkgs.proton-ge-bin ];
      };
    })

    (lib.mkIf cfg.performanceTools {
      programs.gamemode.enable = true;
    })

    (lib.mkIf cfg.ntsync {
      boot.kernelModules = [ "ntsync" ];
    })
  ];
}
