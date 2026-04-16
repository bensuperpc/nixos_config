{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.flashing;

  flashingPackages = with pkgs; [
    qFlipper
    rpi-imager
    arduino
    avrdude
  ];

  enabledOptionalsPackages =
    lib.optionals cfg.tools flashingPackages;

  anyEnabled = lib.any (x: x) [
    cfg.tools
  ];
in
{
  options.myConfig.apps.flashing = {
    tools = moduleHelpers.mkDisabledOption "Install flashing tools";
  };

  config = lib.mkMerge [
    {
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
    })
  ];
}
