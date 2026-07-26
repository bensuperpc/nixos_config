{ lib, pkgs, ... }:

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
      systemd.enable = true;
      systemd.emergencyAccess = true;
    };
    tmp = {
      useZram = true;
      zramSettings.zram-size = "ram * 0.60";
    };

    kernelParams = bootKernelParams;
  };
  environment.systemPackages = bootPackages;
}
