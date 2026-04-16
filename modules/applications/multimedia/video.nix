{ config, lib, pkgs, pkgs-stable, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.multimedia.video;


  editingPackages = with pkgs; [
    obs-studio
    handbrake
    video-compare
    video2x
    subtitleedit
  ];
  playbackPackages = with pkgs; [
    qmplay2
    mpv
    mpvc
    haruna
    vlc
    vlc-bittorrent
    # webtorrent_desktop
  ];
  codecsPackages = with pkgs; [
    ffmpeg-full
    svt-av1
    svt-av1-psyex
    rav1e
    rav1d
    libaom
    vvenc
    libvpx
    xeve
    xevd
    pkgs-stable.av1an
    libcamera
  ];
  opticalMediaPackages = with pkgs; [
    libdvdcss
    libdvdnav
    libdvdread
    makemkv
    libaacs
    libbdplus
  ];
  downloadersPackages = with pkgs; [
    yt-dlp
    gallery-dl
    video-downloader
    media-downloader
  ];

  enabledOptionalsPackages =
    lib.optionals cfg.editing editingPackages
    ++ lib.optionals cfg.playback playbackPackages
    ++ lib.optionals cfg.codecs codecsPackages
    ++ lib.optionals cfg.opticalMedia opticalMediaPackages
    ++ lib.optionals cfg.downloaders downloadersPackages;

  anyEnabled = lib.any (x: x) [
    cfg.editing
    cfg.playback
    cfg.codecs
    cfg.opticalMedia
    cfg.downloaders
  ];
in
{
  options.myConfig.apps.multimedia.video = {
    editing = moduleHelpers.mkDisabledOption "Install video editing, recording, and subtitle tools";

    playback = moduleHelpers.mkDisabledOption "Install video players and playback utilities";

    codecs = moduleHelpers.mkDisabledOption "Install video/audio codec tooling";

    opticalMedia = moduleHelpers.mkDisabledOption "Install DVD and Blu-ray tooling";

    downloaders = moduleHelpers.mkDisabledOption "Install media download tools";
  };

  config = lib.mkMerge [
    {
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
    })
  ];
}

