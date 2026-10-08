# More info: https://wiki.nixos.org/wiki/Bluetooth
{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.drivers.bluetooth;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      enable = {
        description = "Enable Bluetooth stack and tools.";
        packages = [ pkgs.bluez-tools ];
      };
    };
  };
in
{
  options.myConfig.drivers.bluetooth = generated.options;

  config = lib.mkMerge [
    generated.config
    (lib.mkIf cfg.enable {
      myConfig.system.impermanence.persistDirectories = [
        "/var/lib/bluetooth"
        "/var/lib/systemd/rfkill"
      ];

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
    })
  ];
}
