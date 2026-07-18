{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.multimedia.audio;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      editing = {
        description = "Install audio editing and waveform tools";
        packages = with pkgs; [ tenacity audiowaveform audiosource ];
      };
      conversion = {
        description = "Install audio conversion and extraction tools";
        packages = with pkgs; [ lame flacon vgmtrans ];
      };
      library = {
        description = "Install music library and metadata tooling";
        packages = with pkgs; [ beets ];
      };
      playback = {
        description = "Install audio playback control tools";
        packages = with pkgs; [ playerctl ];
      };
    };
  };
in
{
  options.myConfig.apps.multimedia.audio = generated.options;
  config = lib.mkMerge [
    generated.config
    (lib.mkIf cfg.playback {
      services.playerctld.enable = true;
    })
  ];
}
