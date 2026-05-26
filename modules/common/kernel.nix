{ config, lib, pkgs, ... }:

let
  kernelMap = {
    latest   = pkgs.linuxPackages_latest;
    zen      = pkgs.linuxPackages_zen;
    hardened = pkgs.linuxPackages_latest_hardened;
    libre    = pkgs.linuxPackages_latest-libre;
    lts      = pkgs.linuxPackages;
  };
in
{
  options.myConfig.boot.kernel = lib.mkOption {
    type    = lib.types.enum (builtins.attrNames kernelMap);
    default = "latest";
    description = "Kernel variant to use (latest, zen, hardened, libre, lts).";
  };

  config.boot.kernelPackages = lib.mkOverride 50 kernelMap.${config.myConfig.boot.kernel};
}
