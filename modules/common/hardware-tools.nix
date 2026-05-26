{ config, lib, pkgs, moduleHelpers, ... }:

let
  commonPackages = with pkgs; [
    # Common hardware tools/info
    pciutils
    usbutils
    nvme-cli
    dmidecode
  ];
in
{
  environment.systemPackages = commonPackages;
}
