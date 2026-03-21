{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:
{
  imports = [
    ./apps
    ./gui/kdeplasma.nix
  ];
}