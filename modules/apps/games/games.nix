{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  cfg = config.myConfig.apps.games.games;
  basePackages = with pkgs; [ ];
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

  enabledOptionalsPackages =
    lib.optionals cfg.fps fpsPackages
    ++ lib.optionals cfg.arcade arcadePackages
    ++ lib.optionals cfg.sandbox sandboxPackages
    ++ lib.optionals cfg.strategy strategyPackages
    ++ lib.optionals cfg.others othersPackages;

  anyEnabled = lib.any (x: x) [
    cfg.fps
    cfg.arcade
    cfg.sandbox
    cfg.strategy
    cfg.others
  ];
in
{
  options.myConfig.apps.games.games = {
    fps = moduleHelpers.mkEnabledOption "Install FPS and retro shooter games";

    arcade = moduleHelpers.mkEnabledOption "Install arcade and racing games";

    sandbox = moduleHelpers.mkEnabledOption "Install sandbox and factory games";

    strategy = moduleHelpers.mkEnabledOption "Install strategy and board-game engines";

    others = moduleHelpers.mkEnabledOption "Install other miscellaneous games";
  };

  config = lib.mkMerge [
    {
      environment.systemPackages = basePackages;
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
      hardware.graphics.enable = true;
    })
  ];
}
