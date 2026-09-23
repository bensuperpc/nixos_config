{
  config,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.utilities.flashing;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      enable = {
        description = "Install flashing and embedded bus tools";
        packages = with pkgs; [
          qFlipper
          rpi-imager
          arduino
          avrdude
          openocd
          esptool
          platformio
          can-utils
          pioasm
        ];
      };
    };
  };
in
{
  options.myConfig.apps.utilities.flashing = generated.options;
  inherit (generated) config;
}
