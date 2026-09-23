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

  protonPackages = with pkgs; [
    proton-ge-bin
  ];

  protonExtraPackages = with pkgs; [
    protonup-qt
    wineWow64Packages.waylandFull
    vkd3d
  ];
in
{
  options.myConfig.apps.games.steam = {
    client = moduleHelpers.mkDisabledOption "Install and configure Steam client";
    performanceTools = moduleHelpers.mkDisabledOption "Install MangoHud and GameMode";
    useProtonGE = moduleHelpers.mkDisabledOption "Install ProtonGE (registered in Steam) and Wine tooling";
    enableNtsync = moduleHelpers.mkDisabledOption "Enable the ntSync kernel module for improved input latency in games";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.client {
      programs.steam = {
        enable = true;
        protontricks.enable = true;
        remotePlay.openFirewall = true;
        #dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;

        extraPackages = lib.optionals cfg.performanceTools performancePackages;
        extraCompatPackages = lib.optionals cfg.useProtonGE protonPackages;
      };

      environment.systemPackages = [ pkgs.steam-run ];
    })

    (lib.mkIf cfg.performanceTools {
      programs.gamemode.enable = true;
      environment.systemPackages = performancePackages;
    })

    (lib.mkIf cfg.useProtonGE {
      environment.systemPackages = protonExtraPackages;
    })

    (lib.mkIf cfg.enableNtsync {
      boot.kernelModules = [ "ntsync" ];
    })
  ];
}
