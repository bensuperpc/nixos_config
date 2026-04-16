{ lib, pkgs, ... }:
{
  boot = {
    kernelPackages = lib.mkOverride 50 pkgs.linuxPackages_latest_hardened;
    kernelParams = [
      "quiet"
      "splash"
    ];
  };
}
