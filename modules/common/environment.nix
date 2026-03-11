{ pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:

{
  programs.zsh.enable = true;
  programs.bash.enable = true;
  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;

  environment.shellAliases = {
    nrs = "nixos-rebuild switch --max-jobs auto --flake /etc/nixos#${vars.hostname}";
    nrb = "nixos-rebuild build --max-jobs auto --flake /etc/nixos#${vars.hostname}";
    nrt = "nixos-rebuild test --max-jobs auto --flake /etc/nixos#${vars.hostname}";
    nfu = "nix flake update /etc/nixos";
    nsc = "nix-collect-garbage --delete-older-than 7d";
    nsg = "nix-store --gc";
  };

  environment.variables = {
    QT_QPA_PLATFORM = "wayland;xcb";
    GDK_BACKEND = "wayland,x11";
  };

  environment.sessionVariables = {
    # Enable Wayland for Electron apps (e.g. Discord, chromium-based browsers, etc.)
    NIXOS_OZONE_WL = "1";

    # Enable Wayland for Firefox
    MOZ_ENABLE_WAYLAND = "1";

    SDL_VIDEODRIVER = "wayland";

    # Java GUI apps
    _JAVA_AWT_WM_NONREPARENTING = "1";

    EDITOR = "nano";
    BROWSER = "firefox";
    COLORTERM = "truecolor";
  };
}


