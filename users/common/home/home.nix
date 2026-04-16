{ config, osConfig, lib, pkgs, ... }:

{
  programs.home-manager.enable = true;

  programs.mpv = lib.mkIf osConfig.myConfig.apps.multimedia.video.playback {
    enable = true;
    # high-quality, fast, low-latency
    defaultProfiles = lib.mkDefault [ "fast" ];
    scripts = [ pkgs.mpvScripts.mpris ];
  };
}