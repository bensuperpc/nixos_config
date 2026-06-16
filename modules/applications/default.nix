{ config, lib, pkgs, ... }:
{
  imports = [
    ./custom
    ./multimedia
    ./development
    ./games
    ./docker
    ./files
    ./network
    ./desktop
    ./utilities
    ./ai
  ];
}