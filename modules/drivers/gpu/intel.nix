# More info: https://wiki.nixos.org/wiki/Intel_Graphics
{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.drivers.gpu.intel;
in
{
  options.myConfig.drivers.gpu.intel = {
    enable = moduleHelpers.mkDisabledOption "Enable Intel GPU driver stack.";

    generation = lib.mkOption {
      type = lib.types.enum [
        "old"
        "skylake"
        "xe"
      ];
      default = "skylake";
      description = ''
        Intel iGPU generation:
          old      - i965 VA-API driver for Haswell and older
          skylake  - iHD for Broadwell/Skylake to Comet Lake
          xe       - iHD + VPL for Alder Lake and newer
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      extraPackages =
        with pkgs;
        [ libvdpau-va-gl ]
        ++ {
          old = [ intel-vaapi-driver ];
          skylake = [
            intel-media-driver
            intel-compute-runtime-legacy1
          ];
          xe = [
            intel-media-driver
            vpl-gpu-rt
            intel-compute-runtime
          ];
        }
        .${cfg.generation};
    };
    environment.systemPackages = [ pkgs.intel-gpu-tools ];
  };
}
