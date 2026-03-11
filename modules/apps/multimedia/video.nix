{ pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:

{
  environment.systemPackages = with pkgs; [
    # Video editing/recording
    obs-studio
    handbrake
    # Video players and codecs
    qmplay2
    mpv
    mpvc
    haruna
    vlc
    vlc-bittorrent
    ffmpeg-full
    video-compare
    # AV1 encoders/decoders
    svt-av1
    svt-av1-psyex
    rav1e
    rav1d
    libaom
    # MPEG-5
    xeve
    xevd
    # DVD
    libdvdcss
    libdvdnav
    libdvdread
    # Blu-ray
    makemkv
    libaacs
    libbdplus
    # Video/Media downloader
    yt-dlp
    gallery-dl
    video-downloader
    media-downloader
    # IA search
    # rclip
    # AI Upscaling
    video2x
    # buggy in unstable
    pkgs-stable.av1an
    # Video subtitle editing
    subtitleedit
  ];
}