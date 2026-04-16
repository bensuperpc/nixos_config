{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.games.minecraft;
  launcherPackages = with pkgs; [
    prismlauncher
    jre25_minimal # 26.1+
  ];
  jresPackages = with pkgs; [
    jre8 # MC 1.12-1.16 (older works but with some issues)
    jre11_minimal
    jre17_minimal # MC 1.18-1.19
    jre21_minimal # MC 1.20-1.21
  ];
  toolsPackages = with pkgs; [
    mcaselector
    worldpainter
    # Minecraft font
    minecraftia
  ];

  enabledOptionalsPackages =
    lib.optionals cfg.launcher launcherPackages
    ++ lib.optionals cfg.installJres jresPackages
    ++ lib.optionals cfg.installTools toolsPackages;

  anyEnabled = lib.any (x: x) [
    cfg.launcher
    cfg.installJres
    cfg.installTools
  ];
in
{
  options.myConfig.apps.games.minecraft = {
    launcher = moduleHelpers.mkDisabledOption "Install Prism Launcher and default Java runtime";

    installJres = moduleHelpers.mkDisabledOption "Install multiple Java runtimes for modpack compatibility";

    installTools = moduleHelpers.mkDisabledOption "Install Minecraft tools";
  };

  config = lib.mkMerge [
    {
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
      programs.java.enable = true;
    })
  ];
}
