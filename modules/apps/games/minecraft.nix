{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  cfg = config.myConfig.apps.games.minecraft;
  basePackages = with pkgs; [
  ];

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
    launcher = moduleHelpers.mkEnabledOption "Install Prism Launcher and default Java runtime";

    installJres = moduleHelpers.mkEnabledOption "Install multiple Java runtimes for modpack compatibility";

    installTools = moduleHelpers.mkEnabledOption "Install Minecraft tools";
  };

  config = lib.mkMerge [
    {
      environment.systemPackages = basePackages;
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;

      hardware.graphics.enable = true;
      programs.java.enable = true;
    })
  ];
}
