{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.tmux;
in
{
  options.myConfig.apps.tmux.enable =
    moduleHelpers.mkEnabledOption "tmux with its plugins and configuration";

  config.programs.tmux = lib.mkIf cfg.enable {
    enable = true;
    plugins = with pkgs; [
      tmuxPlugins.sensible
    ];
    extraConfig = builtins.readFile ./../asset/tmux.cfg;
  };
}
