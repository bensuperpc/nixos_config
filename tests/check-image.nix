# tests/check-image.nix
{ config, pkgs, lib, ... }:

let
  requiredImagePkgs = with pkgs; [
    # image.editing
    krita
    gimp
    imagemagick
    darktable
    inkscape
    # image.graphing
    gnuplot
    # image.management
    digikam
    # image.formats
    libjxl
    # image.utilities
    pencil2d
    mediainfo
  ];
in
{
  assertions =
    [
      {
        assertion = config.myConfig.apps.multimedia.image.editing;
        message = "Multimedia image editing group must be enabled";
      }
      {
        assertion = config.myConfig.apps.multimedia.image.graphing;
        message = "Multimedia image graphing group must be enabled";
      }
      {
        assertion = config.myConfig.apps.multimedia.image.management;
        message = "Multimedia image management group must be enabled";
      }
      {
        assertion = config.myConfig.apps.multimedia.image.formats;
        message = "Multimedia image formats group must be enabled";
      }
      {
        assertion = config.myConfig.apps.multimedia.image.utilities;
        message = "Multimedia image utilities group must be enabled";
      }
    ]
    ++ map (pkg: {
      assertion = lib.elem pkg config.environment.systemPackages;
      message = "Package missing: ${pkg.name}";
    }) requiredImagePkgs;
}