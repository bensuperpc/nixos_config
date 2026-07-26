{
  config,
  osConfig,
  lib,
  pkgs,
  userVars,
  ...
}:

{
  programs.tmux = {
    enable = true;
    plugins = with pkgs; [
      tmuxPlugins.sensible
    ];
    extraConfig = builtins.readFile ./../asset/tmux.cfg;
  };
}
