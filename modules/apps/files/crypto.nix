{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  cfg = config.myConfig.apps.files.crypto;

  basePackages = with pkgs; [ ];

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
    veracrypt = moduleHelpers.mkEnabledOption "Install VeraCrypt";
  };

  config = lib.mkMerge [
    {
      environment.systemPackages = basePackages;
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
    })
  ];
}
