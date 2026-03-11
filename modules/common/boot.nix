{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:

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

    kernelParams = [
      "quiet"
      "splash"
    ];
  };
}