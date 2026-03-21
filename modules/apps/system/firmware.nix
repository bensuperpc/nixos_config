
{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

{
  boot.loader.efi.canTouchEfiVariables = true;
  services.fwupd.enable = true;

  hardware.enableRedistributableFirmware = true;
  environment.systemPackages = with pkgs; [
    fwupd-efi
  ];
}