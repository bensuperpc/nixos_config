# More info: https://wiki.nixos.org/wiki/AMD_GPU
{ pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:

{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  environment.systemPackages = with pkgs; [
    bluez
  ];
  # services.blueman.enable = true;
}