{ pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:

{
  environment.systemPackages = with pkgs; [
    # Image editing/drawing
    krita
    gimp
    imagemagick
    darktable
    inkscape
    gnuplot
    graphviz
    # Photo management
    digikam
    photoprism
    kphotoalbum
    # Image viewers
    vipsdisp
    # PDF tools
    pdftk
    # Media tools
    mediainfo
    # 2D animation
    pencil2d
    # HDR
    openexr_2
    # JPEG
    libjpeg-tools
    # AVIF
    libavif
    # WebP
    libwebp
    # JPEG XL
    libjxl
    # SVG
    librsvg
  ];
}