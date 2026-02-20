{ pkgs, inputs, vars, ... }:

{
  environment.shellAliases = {
    nrs = "sudo nixos-rebuild switch --max-jobs auto --flake /etc/nixos#${vars.hostname}";
    nrb = "sudo nixos-rebuild build --max-jobs auto --flake /etc/nixos#${vars.hostname}";
    nrt = "sudo nixos-rebuild test --max-jobs auto --flake /etc/nixos#${vars.hostname}";
    nfu = "sudo nix flake update /etc/nixos";
    nsc = "sudo nix-collect-garbage -d";
  };

  environment.variables = {
    QT_QPA_PLATFORM="wayland";
    EDITOR = "nano";
  };

  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;

  # Enable Wayland for Electron apps (e.g. Discord, chromium-based browsers, etc.)
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    COLORTERM = "truecolor";
    TERM = "xterm-256color";
  };
}


