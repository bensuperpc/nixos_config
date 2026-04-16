{ config, lib, pkgs, pkgs-stable, ... }:
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
  ];
}