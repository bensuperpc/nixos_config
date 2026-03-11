{ pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:
{
  imports = [
    ./video.nix
    ./audio.nix
    ./image.nix
    ./misc.nix
  ];
}