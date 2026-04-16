{ config, lib, pkgs, ... }:

let
  cfg = config.myConfig.apps.multimedia;
in
{
  imports = [
    ./video.nix
    ./audio.nix
    ./image.nix
    ./documents.nix
  ];
}
