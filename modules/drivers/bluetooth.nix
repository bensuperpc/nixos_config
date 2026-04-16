# More info: https://wiki.nixos.org/wiki/Bluetooth
{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.drivers.bluetooth;
in
{
  options.myConfig.drivers.bluetooth = {
    enable = moduleHelpers.mkDisabledOption "Enable Bluetooth stack and tools.";
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;
          FastConnectable = true;
        };
      };
    };

    environment.systemPackages = with pkgs; [
      bluez
      bluez-tools
    ];
  };
}