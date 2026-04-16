{ config, lib, pkgs, ... }:

let
  bootKernelParams = [
    "quiet"
    "splash"
  ];
in
{
  boot = {
    # Bootloader.
    loader.systemd-boot.enable = true;
    tmp = {
      useZram = true;
      zramSettings.zram-size = "ram * 0.5";
      #useTmpfs = true;
      #tmpfsHugeMemoryPages = false;
      #tmpfsSize = "60%";
    };

    kernelParams = lib.mkDefault bootKernelParams;
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  };
}