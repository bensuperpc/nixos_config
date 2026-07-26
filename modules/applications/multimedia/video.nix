{
  config,
  lib,
  pkgs,
  pkgsSets,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.multimedia.video;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      editing = {
        description = "Install video editing, recording, and subtitle tools";
        packages = with pkgs; [
          obs-studio
          handbrake
          video-compare
          video2x
          subtitleedit
          kdePackages.kdenlive
          shotcut
          losslesscut
          # natron # Broken
        ];
      };
      playback = {
        description = "Install video players and playback utilities";
        packages = with pkgs; [
          qmplay2
          mpv
          mpvc
          haruna
          vlc
          vlc-bittorrent
          # webtorrent_desktop
        ];
      };
      codecs = {
        description = "Install video/audio codec tooling";
        packages = with pkgs; [
          ffmpeg-full
          dav1d
          svt-av1
          svt-av1-hdr
          rav1e
          rav1d
          libaom
          vvenc
          libvpx
          xeve
          xevd
          av1an
          libcamera
          openjph
          x264
          openh264
          x265
          xvidcore
          libheif
          libde265
        ];
      };
      opticalMedia = {
        description = "Install DVD and Blu-ray tooling";
        packages = (with pkgs; [
          libdvdcss
          libdvdnav
          libdvdread
          mkvtoolnix
          libaacs
          libbdplus
        ]) ++ (with pkgsSets.stable-2605; [
          # makemkv
        ]);
      };
      downloaders = {
        description = "Install media download tools";
        packages = with pkgs; [
          yt-dlp
          gallery-dl
          video-downloader
          media-downloader
        ];
      };
    };
  };
in
{
  options.myConfig.apps.multimedia.video = generated.options;
  inherit (generated) config;
}
