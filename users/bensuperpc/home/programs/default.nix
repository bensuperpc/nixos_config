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
    ./flatpak.nix
    ./shell.nix
  ];

  # environment.shellAliases = {
  # };
}
