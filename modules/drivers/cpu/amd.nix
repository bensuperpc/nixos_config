{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.drivers.cpu.amd;
in
{
  options.myConfig.drivers.cpu.amd.enable =
    moduleHelpers.mkDisabledOption "Enable AMD CPU driver stack.";

  config = lib.mkIf cfg.enable {
    boot = {
      kernelModules = [ "kvm-amd" ];
    };
  };
}
