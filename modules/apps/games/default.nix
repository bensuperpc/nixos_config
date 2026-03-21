{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  cfg = config.myConfig.apps.games;
in
{
  imports = [
    ./emulator.nix
    ./minecraft.nix
    ./steam.nix
    ./games.nix
  ];

  options.myConfig.apps.games = {
    enableAll = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Activate all gaming-related apps and tools";
    };
  };

  config = lib.mkIf cfg.enableAll {
    myConfig.apps.games.emulator = {
      nintendo = lib.mkDefault true;
      sony = lib.mkDefault true;
      retro = lib.mkDefault true;
      xbox = lib.mkDefault true;
      sega = lib.mkDefault true;
      experimental = lib.mkDefault true;
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
    };

    environment.systemPackages = with pkgs; [
      heroic
      lutris
    ];
  };
}