{ config, lib, pkgs, pkgsSets, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.games.games;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      fps = {
        description = "Install FPS and retro shooter games";
        packages = with pkgs; [
          vkquake
          doomretro
          chocolate-doom
          openarena
          #    xonotic
          #    redeclipse
          #    unvanquished
        ];
      };
      arcade = {
        description = "Install arcade and racing games";
        packages = with pkgs; [ extremetuxracer supertux supertuxkart ];
      };
      sandbox = {
        description = "Install sandbox and factory games";
        packages = with pkgs; [ classicube luanti mindustry-wayland ];
      };
      strategy = {
        description = "Install strategy and board-game engines";
        packages = with pkgs; [ stockfish ];
      };
      others = {
        description = "Install other miscellaneous games";
        packages = with pkgs; [ nanosaur nanosaur2 ];
      };
      launchers = {
        description = "Install game store launchers (Heroic, Lutris)";
        packages = with pkgs; [ heroic lgogdownloader lgogdownloader-gui lutris ];
      };
    };
  };
in
{
  options.myConfig.apps.games.games = generated.options;
  config = generated.config;
}
