{ pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:

{
  imports = [
    ./emulator.nix
    ./minecraft.nix
    ./steam.nix
  ];

  environment.systemPackages = with pkgs; [
    # Drivers
    # tuxbox
    # Game launchers
    pkgs-stable.heroic
    stockfish
    # fishnet
    # Compatibility layers
    vkquake
    # Games
    doomretro
    chocolate-doom
    #zdoom
    extremetuxracer
    supertux
    supertuxkart
  ];
}