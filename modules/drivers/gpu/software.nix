{
  config,
  lib,
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
    hardware.graphics.enable = true;
    environment.variables = {
      LIBGL_ALWAYS_SOFTWARE = "1";
    };
  };
}
