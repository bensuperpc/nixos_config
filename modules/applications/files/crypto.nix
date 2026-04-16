{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.files.crypto;

  cryptoPackages = with pkgs; [
    veracrypt
  ];

  enabledOptionalsPackages =
    lib.optionals cfg.veracrypt cryptoPackages;

  anyEnabled = lib.any (x: x) [
    cfg.veracrypt
  ];
in
{
  options.myConfig.apps.files.crypto = {
    veracrypt = moduleHelpers.mkDisabledOption "Install VeraCrypt";
  };

  config = lib.mkMerge [
    {
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
    })
  ];
}
