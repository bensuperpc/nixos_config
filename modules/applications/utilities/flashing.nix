{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.flashing;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      tools = {
        description = "Install flashing tools";
        packages = with pkgs; [
          qFlipper
          rpi-imager
          arduino
          avrdude
          openocd
          esptool
          platformio
        ];
      };
    };
  };
in
{
  options.myConfig.apps.flashing = generated.options;
  inherit (generated) config;
}
