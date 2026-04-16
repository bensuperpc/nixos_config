# profiles/games.nix — games, emulators and minecraft launchers.
{ config, lib, pkgs, ... }:
{
  imports = [
    ../../tests/check-game.nix
  ];

  myConfig.apps.games.emulator = {
    nintendo = lib.mkDefault true;
    sony = lib.mkDefault true;
    retro = lib.mkDefault true;
    xbox = lib.mkDefault true;
    sega = lib.mkDefault true;
  };

  myConfig.apps.games.steam = {
    client = lib.mkDefault true;
    performanceTools = lib.mkDefault true;
    useProtonGE = lib.mkDefault true;
    enableNtsync = lib.mkDefault true;
  };

  myConfig.apps.games.minecraft = {
    launcher = lib.mkDefault true;
    installJres = lib.mkDefault true;
    installTools = lib.mkDefault true;
  };

  myConfig.apps.games.games = {
    fps = lib.mkDefault true;
    arcade = lib.mkDefault true;
    sandbox = lib.mkDefault true;
    strategy = lib.mkDefault true;
    others = lib.mkDefault true;
    launchers = lib.mkDefault true;
  };
}
