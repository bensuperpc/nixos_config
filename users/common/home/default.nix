{ lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:
{
  imports = [
    ./plasma.nix
    ./shell.nix
    ./xdg.nix
  ];
}