{ pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:

{
  environment.systemPackages = with pkgs; [
    # Minecraft launchers and tools
    prismlauncher
    jre8
    jre17_minimal
    jre21_minimal
    jre25_minimal
    # Tools
    mcaselector
    worldpainter
    # Miscs
    minecraftia
    # Forks
    classicube
    luanti
  ];
}