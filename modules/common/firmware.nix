
{ config, lib, pkgs, ... }:

{
  boot.loader.efi.canTouchEfiVariables = true;
  services.fwupd.enable = true;

  hardware.enableRedistributableFirmware = true;
  environment.systemPackages = with pkgs; [
    fwupd-efi
  ];
}