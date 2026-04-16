{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.multimedia.image;


  editingPackages = with pkgs; [
    krita
    gimp
    imagemagick
    darktable
    inkscape
  ];
  graphingPackages = with pkgs; [
    gnuplot
    graphviz
    drawio
  ];
  managementPackages = with pkgs; [
    digikam
    photoprism
    kphotoalbum
    vipsdisp
  ];
  formatsPackages = with pkgs; [
    libjpeg-tools
    libavif
    libwebp
    libjxl
    librsvg
  ];
  utilitiesPackages = with pkgs; [
    mediainfo
    pencil2d
  ];

  enabledOptionalsPackages =
    lib.optionals cfg.editing editingPackages
    ++ lib.optionals cfg.graphing graphingPackages
    ++ lib.optionals cfg.management managementPackages
    ++ lib.optionals cfg.formats formatsPackages
    ++ lib.optionals cfg.utilities utilitiesPackages;

  anyEnabled = lib.any (x: x) [
    cfg.editing
    cfg.graphing
    cfg.management
    cfg.formats
    cfg.utilities
  ];
in
{
  options.myConfig.apps.multimedia.image = {
    editing = moduleHelpers.mkDisabledOption "Install image editing and drawing tools";

    graphing = moduleHelpers.mkDisabledOption "Install plotting and diagram tooling";

    management = moduleHelpers.mkDisabledOption "Install photo management and viewing tools";

    formats = moduleHelpers.mkDisabledOption "Install image format conversion and codec tools";

    utilities = moduleHelpers.mkDisabledOption "Install media and animation utilities";
  };

  config = lib.mkMerge [
    {
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
    })
  ];
}
