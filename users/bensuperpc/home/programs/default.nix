{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./ssh.nix
    ./vscode.nix
    ./mpv.nix
    ./git.nix
    ./ccache.nix
    ./tmux.nix
    ./chromium.nix
    ./firefox.nix
    ./shell.nix
  ];

  # environment.shellAliases = {
  # };
}
