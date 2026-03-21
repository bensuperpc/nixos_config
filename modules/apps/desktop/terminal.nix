{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  cfg = config.myConfig.apps.terminal;
in
{
  options.myConfig.apps.terminal = {
    enable = moduleHelpers.mkDisabledOption "Install additional modern GPU-accelerated terminals";
  };

  config = lib.mkMerge [
    {
      environment.systemPackages = with pkgs; [
        xterm
        foot
        # termite
      ] ++ lib.optionals cfg.enable [
        alacritty-graphics
        alacritty-theme
        wezterm
        terminator
        wezterm
      ];
    }
  ];
}

