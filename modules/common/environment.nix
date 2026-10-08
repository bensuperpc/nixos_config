{
  config,
  lib,
  pkgs,
  ...
}:

let
  hasGui = config.myConfig.gui.desktop != "none";

  shellPackages = with pkgs; [
    vim-full
    neovim
    helix
  ];

  flake = config.programs.nh.flake;

  shellAliases = {
    nrs = "nixos-rebuild switch --sudo --flake ${flake}#${config.networking.hostName}";
    nrb = "nixos-rebuild build --flake ${flake}#${config.networking.hostName}";
    nrt = "nixos-rebuild test --sudo --flake ${flake}#${config.networking.hostName}";
    nsc = "nh clean all --keep 5 --keep-since 14d";
    nsr = "nix-collect-garbage --repair";
    nso = "nix-store --optimise";
    nds = "nix path-info -Sh /run/current-system";
  };

  guiVariables = {
    QT_QPA_PLATFORM = "wayland;xcb";
    GDK_BACKEND = "wayland,x11";
  };

  guiSessionVariables = {
    # Enable Wayland for Electron apps (e.g. Discord, chromium-based browsers, etc.)
    NIXOS_OZONE_WL = "1";

    SDL_VIDEODRIVER = "wayland,x11";

    # Java GUI apps
    _JAVA_AWT_WM_NONREPARENTING = "1";

    BROWSER = "firefox";
  };

  sessionVariables = {
    EDITOR = "nano";
    VISUAL = "nano";
    COLORTERM = "truecolor";
  };
in
{
  programs.zsh.enable = true;
  programs.bash.enable = true;

  environment = {
    shells = with pkgs; [
      zsh
      bashInteractive
    ];
    systemPackages = shellPackages;
    variables = lib.mkIf hasGui guiVariables;
    sessionVariables = sessionVariables // lib.optionalAttrs hasGui guiSessionVariables;
    inherit shellAliases;
  };
}
