{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

{
  imports = [
    ./base.nix
    # Tests
    ../tests/check-video.nix
    ../tests/check-image.nix
    ../tests/check-audio.nix
  ];
  # Preset for content creation workloads.
  myConfig.apps.multimedia.enableAll = true;
}