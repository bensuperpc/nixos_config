{ lib, pkgs, ... }:
{
  boot = {
    kernelPackages = lib.mkOverride 50 pkgs.linuxPackages_latest-libre;
    kernelParams = [
      "quiet"
      "splash"
    ];
  };
}
