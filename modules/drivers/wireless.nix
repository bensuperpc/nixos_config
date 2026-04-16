{ config, lib, moduleHelpers, ... }:

let
  cfg = config.myConfig.drivers.wireless;
in
{
  options.myConfig.drivers.wireless = {
    enable = moduleHelpers.mkDisabledOption "Enable wireless support (wpa_supplicant).";
  };

  config = lib.mkIf cfg.enable {
    networking.wireless.enable = true;
  };
}