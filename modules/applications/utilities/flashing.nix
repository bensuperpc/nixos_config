{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.utilities.flashing;

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
  options.myConfig.apps.utilities.flashing = generated.options;
  inherit (generated) config;
}
