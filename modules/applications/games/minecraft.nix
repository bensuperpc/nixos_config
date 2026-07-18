{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.games.minecraft;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      launcher = {
        description = "Install Prism Launcher and default Java runtime";
        packages = with pkgs; [
          prismlauncher
          jre25_minimal # 26.1+
        ];
      };
      installJres = {
        description = "Install multiple Java runtimes for modpack compatibility";
        packages = with pkgs; [
          jre8 # MC 1.12-1.16 (older works but with some issues)
          jre11_minimal
          jre17_minimal # MC 1.18-1.19
          jre21_minimal # MC 1.20-1.21
        ];
      };
      installTools = {
        description = "Install Minecraft tools";
        packages = with pkgs; [
          mcaselector
          worldpainter
          # Minecraft font
          minecraftia
        ];
      };
    };
  };
in
{
  options.myConfig.apps.games.minecraft = generated.options;
  config = lib.mkMerge [
    generated.config
    (lib.mkIf generated.anyEnabled {
      programs.java.enable = true;
    })
  ];
}
