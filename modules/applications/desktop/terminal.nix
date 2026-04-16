{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.terminal;
in
{
  options.myConfig.apps.terminal = {
    enable = moduleHelpers.mkDisabledOption "Install additional modern GPU-accelerated terminals";
  };

  config = lib.mkMerge [
    {
      environment.systemPackages = with pkgs; lib.optionals cfg.enable [
        alacritty-graphics
        alacritty-theme
        terminator
        wezterm
        foot
        xterm
      ];
    }
  ];
}

