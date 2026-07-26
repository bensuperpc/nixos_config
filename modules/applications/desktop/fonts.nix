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
  imports = [
    (lib.mkAliasOptionModule
      [ "myConfig" "apps" "additionalFonts" ]
      [ "myConfig" "apps" "desktop" "fonts" ]
    )
  ];

  options.myConfig.apps.desktop = {
    fonts.nerdFonts = moduleHelpers.mkDisabledOption "Enable Nerd Fonts package set";
  };

  config = lib.mkMerge [
    {
      fonts = {
        fontconfig.enable = true;
        enableDefaultPackages = true;
        packages =
          defaultFonts
          # More info: https://nixos.wiki/wiki/Fonts
          ++ lib.optionals cfg.nerdFonts (
            builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts)
          );
      };
    }
  ];
}
