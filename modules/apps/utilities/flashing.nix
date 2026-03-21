{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  cfg = config.myConfig.apps.flashing;

  basePackages = with pkgs; [ ];

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
    tools = moduleHelpers.mkEnabledOption "Install flashing tools";
  };

  config = lib.mkMerge [
    {
      environment.systemPackages = basePackages;
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
    })
  ];
}
