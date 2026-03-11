{ pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:
{
  imports = [
    ./common
    ./apps
    ./services
    ./gui/kdeplasma.nix
  ];
}