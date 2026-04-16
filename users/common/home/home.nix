{ config, osConfig, lib, pkgs, ... }:

{
  programs.home-manager.enable = true;

  programs.mpv = lib.mkIf osConfig.myConfig.apps.multimedia.video.playback {
    enable = true;
    # high-quality, fast, low-latency
    defaultProfiles = lib.mkDefault [ "fast" ];
    scripts = [ pkgs.mpvScripts.mpris ];
  };

  # Reset on each update
  # home.activation.resetPlasma = config.lib.dag.entryBefore ["checkLinkTargets"] ''
  #   shopt -s nullglob

  #   for path in \
  #     "$HOME/.config/plasma"* \
  #     "$HOME/.config/kde"* \
  #     "$HOME/.config/kwin"* \
  #     "$HOME/.config/kscreen"* \
  #     "$HOME/.config/kdeglobals" \
  #     "$HOME/.local/share/plasma" \
  #     "$HOME/.local/share/kactivitymanagerd" \
  #     "$HOME/.local/share/kscreen" \
  #     "$HOME/.cache/plasma"* \
  #     "$HOME/.cache/kscreen"*; do

  #     rm -rf "$path"
  #   done
  # '';
}