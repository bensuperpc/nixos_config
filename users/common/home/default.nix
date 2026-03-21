{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

{
  imports = [
    ./home.nix
    ./plasma.nix
    ./shell.nix
    ./xdg.nix
  ];
}