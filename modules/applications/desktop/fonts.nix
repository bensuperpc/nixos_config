{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.desktop.fonts;

  defaultFonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk-serif
    noto-fonts-lgc-plus
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];
in
{
  options.myConfig.apps.desktop.fonts = {
    enable = moduleHelpers.mkEnabledOption "Noto fonts and fontconfig";
    nerdFonts = moduleHelpers.mkDisabledOption "Install a selection of Nerd Fonts";
  };

  config = lib.mkIf cfg.enable {
    fonts = {
      fontconfig.enable = true;
      enableDefaultPackages = true;
      packages =
        defaultFonts
        # More info: https://nixos.wiki/wiki/Fonts
        ++ lib.optionals cfg.nerdFonts (
          with pkgs.nerd-fonts;
          [
            jetbrains-mono
            fira-code
            hack
            symbols-only
          ]
        );
    };
  };
}
