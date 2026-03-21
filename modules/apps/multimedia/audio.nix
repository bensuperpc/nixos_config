{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  cfg = config.myConfig.apps.multimedia.audio;
  basePackages = with pkgs; [ ];
  editingPackages = with pkgs; [
    tenacity
    audiowaveform
    audiosource
  ];
  conversionPackages = with pkgs; [
    lame
    flacon
    vgmtrans
  ];
  libraryPackages = with pkgs; [
    beets
  ];
  playbackPackages = with pkgs; [
    playerctl
  ];

  enabledOptionalsPackages =
    lib.optionals cfg.editing editingPackages
    ++ lib.optionals cfg.conversion conversionPackages
    ++ lib.optionals cfg.library libraryPackages
    ++ lib.optionals cfg.playback playbackPackages;

  anyEnabled = lib.any (x: x) [
    cfg.editing
    cfg.conversion
    cfg.library
    cfg.playback
  ];
in
{
  options.myConfig.apps.multimedia.audio = {
    editing = moduleHelpers.mkEnabledOption "Install audio editing and waveform tools";

    conversion = moduleHelpers.mkEnabledOption "Install audio conversion and extraction tools";

    library = moduleHelpers.mkEnabledOption "Install music library and metadata tooling";

    playback = moduleHelpers.mkEnabledOption "Install audio playback control tools";
  };

  config = lib.mkMerge [
    {
      environment.systemPackages = basePackages;
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
    })

    (lib.mkIf cfg.playback {
      services.playerctld.enable = true;
    })
  ];
}
