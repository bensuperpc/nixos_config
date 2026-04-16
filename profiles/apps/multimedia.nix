{ config, lib, pkgs, ... }:

{
  imports = [
    # Tests
    ../../tests/check-video.nix
    ../../tests/check-image.nix
    ../../tests/check-audio.nix
  ];
  # Preset for content creation workloads.
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

  myConfig.apps.multimedia.documents = {
    reading = lib.mkDefault true;
    pdf = lib.mkDefault true;
  };
}