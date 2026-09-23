{ config, pkgs, ... }:

let
  bootKernelParams = [
    "quiet"
    "splash"
  ];
  bootPackages = with pkgs; [
    sbctl
    efibootmgr
    efitools
    efivar
  ];
in
{
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        configurationLimit = 50;
        editor = false;
      };
    };
    initrd = {
      systemd = {
        enable = true;
        # Disable for security reasons
        emergencyAccess = false;
      };
    };

    tmp = {
      useZram = true;
      zramSettings.zram-size = "ram * 0.20";
    };

    kernelParams = bootKernelParams;
  };
  environment.systemPackages = bootPackages;

  assertions = [
    {
      assertion =
        config.wsl.enable
        || config.boot.loader.systemd-boot.enable
        || config.boot.lanzaboote.enable
        || config.boot.loader.grub.enable;
      message = "No bootloader enabled: enable systemd-boot (or Lanzaboote via platform/secureboot).";
    }
  ];
}
