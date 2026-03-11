
{ pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:

{
  boot.loader.efi.canTouchEfiVariables = true;
  services.fwupd.enable = true;
  environment.systemPackages = with pkgs; [
    fwupd-efi
  ];
}