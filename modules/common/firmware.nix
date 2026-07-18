{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.firmware;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      enable = {
        description = "Enable firmware management";
        enabledByDefault = true;
        packages = with pkgs; [ fwupd-efi ];
      };
    };
  };
in
{
  options.myConfig.apps.firmware = generated.options;

  config = lib.mkMerge [
    {
      nixpkgs.config.allowUnfree = true;
    }
    generated.config
    (lib.mkIf generated.anyEnabled {
      hardware.enableAllFirmware = true;
      hardware.enableRedistributableFirmware = true;

      services.fwupd.enable = true;
    })
  ];
}
