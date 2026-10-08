{
  config,
  lib,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.system.firmware;
in
{
  options.myConfig.system.firmware.enable =
    moduleHelpers.mkEnabledOption "Enable firmware management";

  config = lib.mkIf cfg.enable {
    myConfig.system.impermanence.persistDirectories = [ "/var/lib/fwupd" ];

    hardware.enableAllFirmware = true;

    services.fwupd.enable = true;
  };
}
