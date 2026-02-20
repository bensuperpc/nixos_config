{ pkgs, inputs, vars, ... }:
{
  imports = [
    ./video.nix
    ./audio.nix
    ./image.nix
    ./misc.nix
  ];
}