
{ config, lib, pkgs, ... }:

{
  boot.loader.efi.canTouchEfiVariables = true;
  nixpkgs.config.allowUnfree = true;

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  
  services.fwupd.enable = true;
  environment.systemPackages = with pkgs; [
    fwupd-efi
  ];
}