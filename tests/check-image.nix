# tests/check-image.nix
{ config, pkgs, lib, vars, ... }:

let
  requiredImagePkgs = with pkgs; [
    # Image editing
    krita
    gimp
    imagemagick
    darktable
    inkscape
    # 2D animation
    pencil2d
  ];
in
{
  assertions =
    [
    ]
    ++ map (pkg: {
      assertion = lib.elem pkg config.environment.systemPackages;
      message = "Package missing: ${pkg.name}";
    }) requiredImagePkgs;
}