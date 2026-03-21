{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  cfg = config.myConfig.apps.multimedia.video;
  basePackages = with pkgs; [ ];
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
    editing = moduleHelpers.mkEnabledOption "Install video editing, recording, and subtitle tools";

    playback = moduleHelpers.mkEnabledOption "Install video players and playback utilities";

    codecs = moduleHelpers.mkEnabledOption "Install video/audio codec tooling";

    opticalMedia = moduleHelpers.mkEnabledOption "Install DVD and Blu-ray tooling";

    downloaders = moduleHelpers.mkEnabledOption "Install media download tools";
  };

  config = lib.mkMerge [
    {
      environment.systemPackages = basePackages;
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
    })
  ];
}

