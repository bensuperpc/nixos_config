{ pkgs, inputs, vars, ... }:

{
  environment.systemPackages = with pkgs; [
    # Video editing/recording
    obs-studio
    handbrake
    # Video players and codecs
    haruna
    vlc
    vlc-bittorrent
    libdvdcss
    ffmpeg-full
    av1an
    # Video subtitle editing
    subtitleedit
  ];
}