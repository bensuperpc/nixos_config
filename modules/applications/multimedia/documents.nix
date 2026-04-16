{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.multimedia.documents;

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
  options.myConfig.apps.multimedia.documents = {
    reading = moduleHelpers.mkDisabledOption "Install e-book reading tools";

    pdf = moduleHelpers.mkDisabledOption "Install PDF tooling";
  };

  config = lib.mkMerge [
    {
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
    })
  ];
}
