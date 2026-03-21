{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  cfg = config.myConfig.apps.multimedia;
in
{
  imports = [
    ./video.nix
    ./audio.nix
    ./image.nix
    ./misc.nix
  ];

  options.myConfig.apps.multimedia = {
    enableAll = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Activate all multimedia-related apps and tools";
    };
  };

  config = lib.mkIf cfg.enableAll {
    myConfig.apps.multimedia.video = {
      editing = lib.mkDefault true;
      playback = lib.mkDefault true;
      codecs = lib.mkDefault true;
      opticalMedia = lib.mkDefault true;
      downloaders = lib.mkDefault true;
    };

    myConfig.apps.multimedia.audio = {
      editing = lib.mkDefault true;
      conversion = lib.mkDefault true;
      library = lib.mkDefault true;
      playback = lib.mkDefault true;
    };

    myConfig.apps.multimedia.image = {
      editing = lib.mkDefault true;
      graphing = lib.mkDefault true;
      management = lib.mkDefault true;
      formats = lib.mkDefault true;
      utilities = lib.mkDefault true;
    };

    myConfig.apps.multimedia.misc = {
      reading = lib.mkDefault true;
      pdf = lib.mkDefault true;
    };
  };
}
