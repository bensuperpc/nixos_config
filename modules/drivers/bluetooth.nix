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
        packages = with pkgs; [
          bluez
          bluez-tools
        ];
      };
    };
  };
in
{
  options.myConfig.drivers.bluetooth = generated.options;

  config = lib.mkMerge [
    generated.config
    (lib.mkIf cfg.enable {
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
