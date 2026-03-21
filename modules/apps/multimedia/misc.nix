{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  cfg = config.myConfig.apps.multimedia.misc;
  basePackages = with pkgs; [ ];
  readingPackages = with pkgs; [
    calibre
  ];
  pdfPackages = with pkgs; [
    pdfarranger
    pdftk
  ];

  enabledOptionalsPackages =
    lib.optionals cfg.reading readingPackages
    ++ lib.optionals cfg.pdf pdfPackages;

  anyEnabled = lib.any (x: x) [
    cfg.reading
    cfg.pdf
  ];
in
{
  options.myConfig.apps.multimedia.misc = {
    reading = moduleHelpers.mkEnabledOption "Install e-book reading tools";

    pdf = moduleHelpers.mkEnabledOption "Install PDF tooling";
  };

  config = lib.mkMerge [
    {
      environment.systemPackages = basePackages;
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
    })
  ];
}
