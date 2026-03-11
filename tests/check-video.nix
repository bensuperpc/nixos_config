# tests/check-video.nix
{ config, pkgs, lib, vars, ... }:

let
  requiredVideoPkgs = with pkgs; [
    # Video players
    vlc
    haruna
    # Video editing/recording
    obs-studio
    handbrake
    # DVD things
    libdvdnav
    libdvdcss
    libdvdread
    # Blu-ray
    makemkv
    libaacs
    libbdplus
    # Video codecs
    ffmpeg-full
    # Video upscaling
    video2x
  ];
in
{
  assertions =
    [
    ]
    ++ map (pkg: {
      assertion = lib.elem pkg config.environment.systemPackages;
      message = "Package missing: ${pkg.name}";
    }) requiredVideoPkgs;
}