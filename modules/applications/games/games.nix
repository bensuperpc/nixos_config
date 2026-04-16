{ config, lib, pkgs, pkgs-stable, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.games.games;


  fpsPackages = with pkgs; [
    vkquake
    doomretro
    chocolate-doom
  ];
  arcadePackages = with pkgs; [
    extremetuxracer
    supertux
    supertuxkart
  ];
  sandboxPackages = with pkgs; [
    classicube
    luanti
    mindustry-wayland
  ];
  strategyPackages = with pkgs; [
    stockfish
  ];
  othersPackages = with pkgs; [
    nanosaur
    nanosaur2
  ];

  launchersPackages = with pkgs; [
    heroic
    pkgs-stable.lutris
  ];

  enabledOptionalsPackages =
    lib.optionals cfg.fps fpsPackages
    ++ lib.optionals cfg.arcade arcadePackages
    ++ lib.optionals cfg.sandbox sandboxPackages
    ++ lib.optionals cfg.strategy strategyPackages
    ++ lib.optionals cfg.others othersPackages
    ++ lib.optionals cfg.launchers launchersPackages;

  anyEnabled = lib.any (x: x) [
    cfg.fps
    cfg.arcade
    cfg.sandbox
    cfg.strategy
    cfg.others
    cfg.launchers
  ];
in
{
  options.myConfig.apps.games.games = {
    fps = moduleHelpers.mkDisabledOption "Install FPS and retro shooter games";

    arcade = moduleHelpers.mkDisabledOption "Install arcade and racing games";

    sandbox = moduleHelpers.mkDisabledOption "Install sandbox and factory games";

    strategy = moduleHelpers.mkDisabledOption "Install strategy and board-game engines";

    others = moduleHelpers.mkDisabledOption "Install other miscellaneous games";

    launchers = moduleHelpers.mkDisabledOption "Install game store launchers (Heroic, Lutris)";
  };

  config = lib.mkMerge [
    {
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
    })
  ];
}
