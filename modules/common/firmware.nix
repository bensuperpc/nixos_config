
{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.firmware;

  firmwarePackages = with pkgs; [
    fwupd-efi
  ];

  enabledOptionalsPackages =
    lib.optionals cfg.enable firmwarePackages;

  anyEnabled = lib.any (x: x) [
    cfg.enable
  ];
in
{
  options.myConfig.apps.firmware = {
    enable = moduleHelpers.mkEnabledOption "Enable firmware management";
  };

  config = lib.mkMerge [
    {
      nixpkgs.config.allowUnfree = true;
    }
    (lib.mkIf anyEnabled {
      hardware.enableAllFirmware = true;
      hardware.enableRedistributableFirmware = true;
      
      services.fwupd.enable = true;

      environment.systemPackages = enabledOptionalsPackages;
    })
  ];
}