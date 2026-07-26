# More info: https://wiki.nixos.org/wiki/AMD_GPU
{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.drivers.gpu.software;
in
{
  options.myConfig.drivers.gpu.software.enable =
    moduleHelpers.mkDisabledOption "Enable software GPU driver stack.";

  config = lib.mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
    environment.variables = {
      LIBGL_ALWAYS_SOFTWARE = "1";
    };
  };
}
