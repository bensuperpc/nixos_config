{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.multimedia.image;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      editing = {
        description = "Install image editing and drawing tools";
        packages = with pkgs; [
          krita
          gimp
          imagemagick
          darktable
          inkscape
          rawtherapee
          upscayl
        ];
      };
      graphing = {
        description = "Install plotting and diagram tooling";
        packages = with pkgs; [
          gnuplot
          graphviz
          drawio
        ];
      };
      management = {
        description = "Install photo management and viewing tools";
        packages = with pkgs; [
          digikam
          photoprism
          kphotoalbum
          vipsdisp
          gallery-dl
          rawtherapee
        ];
      };
      formats = {
        description = "Install image format conversion and codec tools";
        packages = with pkgs; [
          libjpeg-tools
          libavif
          libwebp
          libjxl
          librsvg

        ];
      };
      utilities = {
        description = "Install media and animation utilities";
        packages = with pkgs; [
          mediainfo
          pencil2d
        ];
      };
      animation = {
        description = "Install animation";
        packages = with pkgs; [
          synfigstudio
        ];
      };
    };
  };
in
{
  options.myConfig.apps.multimedia.image = generated.options;
  inherit (generated) config;
}
