{
  config,
  osConfig,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.mpv;
in
{
  options.myConfig.apps.mpv.enable =
    moduleHelpers.mkBoolOption osConfig.myConfig.apps.multimedia.video.playback "mpv with its scripts (follows the system `apps.multimedia.video.playback` toggle by default)";

  config.programs.mpv = lib.mkIf cfg.enable {
    enable = true;
    # high-quality, fast, low-latency
    defaultProfiles = lib.mkDefault [ "fast" ];
    scripts = [ pkgs.mpvScripts.mpris ];
  };
}
