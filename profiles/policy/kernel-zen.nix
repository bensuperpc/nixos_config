{ lib, pkgs, ... }:
{
  boot = {
    kernelPackages = lib.mkOverride 50 pkgs.linuxPackages_zen;
    kernelParams = [
      "quiet"
      "splash"
    ];
  };
}
