# More info: https://wiki.nixos.org/wiki/AMD_GPU
{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    bluez
    bluez-tools
  ];
}