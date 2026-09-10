{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.drivers.cpu.intel;
in
{
  options.myConfig.drivers.cpu.intel.enable =
    moduleHelpers.mkDisabledOption "Enable Intel CPU driver stack.";

  config = lib.mkIf cfg.enable {
    boot = {
      kernelModules = [ "kvm-intel" ];
    };
  };
}
