{ pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:

{
  environment.systemPackages = with pkgs; [
    # Hardware tools/info
    pciutils
    usbutils
    nvme-cli
    hardinfo2
    hwinfo
    lshw-gui
    smartmontools
    inxi
    dmidecode
    cpuid
  ];
}