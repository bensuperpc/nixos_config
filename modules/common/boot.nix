{ config, lib, pkgs, ... }:

let
  bootKernelParams = [
    "quiet"
    "splash"
  ];
in
{
  boot = {
    loader.systemd-boot.enable = lib.mkDefault true;
    tmp = {
      useZram = lib.mkDefault true;
      zramSettings.zram-size = lib.mkDefault "ram * 0.60";
    };

    kernelParams = lib.mkDefault bootKernelParams;
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  };
}