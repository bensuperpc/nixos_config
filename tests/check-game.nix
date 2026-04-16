# tests/check-game.nix
{ config, pkgs, lib, ... }:

let
  requiredGamePkgs = with pkgs; [
    # emulator.nintendo
    dolphin-emu
    snes9x
    zsnes2
    # emulator.sony
    pcsx2
    # games.fps
    vkquake
    # games.strategy
    stockfish
    # games.sandbox
    luanti
  ];
in
{
  assertions =
    [
      {
        assertion = config.myConfig.apps.games.emulator.nintendo;
        message = "Emulator Nintendo group must be enabled";
      }
      {
        assertion = config.myConfig.apps.games.emulator.sony;
        message = "Emulator Sony group must be enabled";
      }
      {
        assertion = config.myConfig.apps.games.emulator.retro;
        message = "Emulator retro group must be enabled";
      }
      {
        assertion = config.myConfig.apps.games.steam.client;
        message = "Steam client group must be enabled";
      }
      {
        assertion = config.myConfig.apps.games.steam.useProtonGE;
        message = "Steam Proton GE group must be enabled";
      }
      {
        assertion = config.myConfig.apps.games.minecraft.launcher;
        message = "Minecraft launcher group must be enabled";
      }
      {
        assertion = config.myConfig.apps.games.games.fps;
        message = "Games FPS group must be enabled";
      }
      {
        assertion = config.myConfig.apps.games.games.sandbox;
        message = "Games sandbox group must be enabled";
      }
      {
        assertion = config.myConfig.apps.games.games.strategy;
        message = "Games strategy group must be enabled";
      }
    ]
    ++ map (pkg: {
      assertion = lib.elem pkg config.environment.systemPackages;
      message = "Package missing: ${pkg.name}";
    }) requiredGamePkgs;
}