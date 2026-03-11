{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:

{
  hardware = {
    enableRedistributableFirmware = true;
    graphics = {
      enable = true;
    };
  };
}