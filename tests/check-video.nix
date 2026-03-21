# tests/check-video.nix
{ config, pkgs, lib, vars, ... }:

let
  requiredVideoPkgs = with pkgs; [
    # video.playback
    vlc
    haruna
    mpv
    # video.editing
    obs-studio
    handbrake
    video2x
    subtitleedit
    # video.opticalMedia
    libdvdnav
    libdvdcss
    libdvdread
    makemkv
    libaacs
    libbdplus
    # video.codecs
    ffmpeg-full
    svt-av1
    # video.downloaders
    yt-dlp
  ];
in
{
  assertions =
    [
      {
        assertion = config.myConfig.apps.multimedia.video.editing;
        message = "Multimedia video editing group must be enabled";
      }
      {
        assertion = config.myConfig.apps.multimedia.video.playback;
        message = "Multimedia video playback group must be enabled";
      }
      {
        assertion = config.myConfig.apps.multimedia.video.codecs;
        message = "Multimedia video codecs group must be enabled";
      }
      {
        assertion = config.myConfig.apps.multimedia.video.opticalMedia;
        message = "Multimedia video optical media group must be enabled";
      }
      {
        assertion = config.myConfig.apps.multimedia.video.downloaders;
        message = "Multimedia video downloaders group must be enabled";
      }
    ]
    ++ map (pkg: {
      assertion = lib.elem pkg config.environment.systemPackages;
      message = "Package missing: ${pkg.name}";
    }) requiredVideoPkgs;
}