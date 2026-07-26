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
    ./tmux.nix
    ./chromium.nix
    ./firefox.nix
  ];

  # environment.shellAliases = {
  # };
}
