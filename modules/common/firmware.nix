{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.system.firmware;

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
  options.myConfig.system.firmware = generated.options;

  config = lib.mkMerge [
    generated.config
    (lib.mkIf generated.anyEnabled {
      hardware.enableAllFirmware = true;
      hardware.enableRedistributableFirmware = true;

      services.fwupd.enable = true;
    })
  ];
}
