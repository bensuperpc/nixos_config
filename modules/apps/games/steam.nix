{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  cfg = config.myConfig.apps.games.steam;

  basePackages = with pkgs; [
  ];

  steamClientPackages = with pkgs; [
    steam-run
    steam
  ];

  performancePackages = with pkgs; [
    mangohud
    gamemode
  ];

  protonPackages = with pkgs; [
    proton-ge-bin
  ];

  protonExtraPackages = with pkgs; [
    protonup-qt
    wineWow64Packages.waylandFull
    vkd3d
  ];

  enabledOptionalsPackages =
    lib.optionals cfg.performanceTools performancePackages
    ++ lib.optionals cfg.useProtonGE protonExtraPackages
    ++ lib.optionals cfg.client steamClientPackages;

  anyEnabled = lib.any (x: x) [
    cfg.client
    cfg.performanceTools
    cfg.useProtonGE
    cfg.enableNtsync
  ];
in
{
  options.myConfig.apps.games.steam = {
    client = moduleHelpers.mkEnabledOption "Install and configure Steam client";
    performanceTools = moduleHelpers.mkEnabledOption "Install MangoHud and GameMode";
    useProtonGE = moduleHelpers.mkEnabledOption "Install Wine and ProtonGE";
    enableNtsync = moduleHelpers.mkEnabledOption "Enable the ntSync kernel module for improved input latency in games";
  };

  config = lib.mkMerge [
    {
      environment.systemPackages = basePackages;
    }
    (lib.mkIf anyEnabled {
      programs.steam = {
        enable = true;
        protontricks.enable = true;
        remotePlay.openFirewall = true;
        #dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;

        extraPackages =
          lib.optionals cfg.performanceTools performancePackages
          ++ lib.optionals cfg.useProtonGE protonPackages;
      };

      boot.kernelModules = lib.optionals cfg.enableNtsync [ "ntsync" ];

      environment.systemPackages = enabledOptionalsPackages
      ++ lib.optionals (!cfg.client) steamClientPackages;

      hardware.graphics.enable = true;
      hardware.graphics.enable32Bit = true;
    })
  ];
}
