{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  cfg = config.myConfig.apps.additionalFonts;

  defaultFonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk-serif
    noto-fonts-lgc-plus
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];
in
{
  options.myConfig.apps = {
    additionalFonts.nerdFonts = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Nerd Fonts package set";
    };
  };

  config = lib.mkMerge [
    {
      fonts = {
        fontconfig.enable = true;
        enableDefaultPackages = true;
        packages = defaultFonts
        # More info: https://nixos.wiki/wiki/Fonts
          ++ lib.optionals cfg.nerdFonts (builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts));
      };
    }
  ];
}
