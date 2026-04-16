# tests/check-audio.nix
{ config, pkgs, lib, ... }:

let
  requiredAudioPkgs = with pkgs; [
    # audio.editing
    tenacity
    audiowaveform
    # audio.conversion
    lame
    flacon
    # audio.library
    beets
  ];
in
{
  assertions =
    [
      {
        assertion = config.myConfig.apps.multimedia.audio.editing;
        message = "Multimedia audio editing group must be enabled";
      }
      {
        assertion = config.myConfig.apps.multimedia.audio.conversion;
        message = "Multimedia audio conversion group must be enabled";
      }
      {
        assertion = config.myConfig.apps.multimedia.audio.library;
        message = "Multimedia audio library group must be enabled";
      }
      {
        assertion = config.myConfig.apps.multimedia.audio.playback;
        message = "Multimedia audio playback group must be enabled";
      }
    ]
    ++ map (pkg: {
      assertion = lib.elem pkg config.environment.systemPackages;
      message = "Package missing: ${pkg.name}";
    }) requiredAudioPkgs;
}
