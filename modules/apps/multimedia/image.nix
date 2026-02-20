{ pkgs, inputs, vars, ... }:

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
    # Media tools
    mediainfo
    # 2D animation
    pencil2d
  ];
}