{
  config,
  pkgs,
  ...
}:

let
  shellPackages = with pkgs; [
    vim-full
    neovim
    nano
    helix
  ];

  flake = config.programs.nh.flake;

  shellAliases = {
    nrs = "nixos-rebuild switch --sudo --max-jobs auto --flake ${flake}#${config.networking.hostName}";
    nrb = "nixos-rebuild build --max-jobs auto --flake ${flake}#${config.networking.hostName}";
    nrt = "nixos-rebuild test --sudo --max-jobs auto --flake ${flake}#${config.networking.hostName}";
    nsc = "nh clean all --keep 5 --keep-since 14d";
    nsr = "nix-collect-garbage --repair";
    nso = "nix-store --optimise";
    nds = "nix path-info -Sh /run/current-system";
  };

  envVariables = {
    QT_QPA_PLATFORM = "wayland;xcb";
    GDK_BACKEND = "wayland,x11";
  };

  sessionVariables = {
    # Enable Wayland for Electron apps (e.g. Discord, chromium-based browsers, etc.)
    NIXOS_OZONE_WL = "1";

    # Enable Wayland for Firefox
    MOZ_ENABLE_WAYLAND = "1";

    SDL_VIDEODRIVER = "wayland,x11";

    # Java GUI apps
    _JAVA_AWT_WM_NONREPARENTING = "1";

    EDITOR = "nano";
    VISUAL = "nano";
    BROWSER = "chromium";
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
    variables = envVariables;
    inherit shellAliases sessionVariables;
  };
}
