{ config, lib, pkgs, ... }:

{
  imports = [
    ./home.nix
    ./plasma.nix
    ./shell.nix
    ./xdg.nix
  ];
}