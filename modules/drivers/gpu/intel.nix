# More info: https://wiki.nixos.org/wiki/Intel_Graphics
{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.drivers.gpu.intel;
  anyEnabled = cfg.enableOldDriver || cfg.enableSkylakeDriver || cfg.enableXeDriver;
in
{
  options.myConfig.drivers.gpu = {
    intel.enableOldDriver = moduleHelpers.mkDisabledOption "Enable Intel old driver stack for Haswell and older GPUs.";
    intel.enableSkylakeDriver = moduleHelpers.mkDisabledOption "Enable Intel driver stack for Skylake to Comet Lake GPUs.";
    intel.enableXeDriver = moduleHelpers.mkDisabledOption "Enable Intel Xe driver stack for Alder Lake and newer GPUs.";
  };

  config = lib.mkMerge [
    (lib.mkIf anyEnabled {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          libvdpau-va-gl
          libva
          libva-vdpau-driver
        ];
      };

      environment.systemPackages = with pkgs; [
        intel-gpu-tools
        mesa
      ];
    })

    (lib.mkIf cfg.enableOldDriver {
      hardware.graphics.extraPackages = with pkgs; [
        intel-vaapi-driver
      ];
    })

    (lib.mkIf cfg.enableSkylakeDriver {
      hardware.graphics.extraPackages = with pkgs; [
        intel-media-driver
        intel-compute-runtime-legacy1
      ];
    })

    (lib.mkIf cfg.enableXeDriver {
      hardware.graphics.extraPackages = with pkgs; [
        intel-media-driver
        vpl-gpu-rt
        intel-compute-runtime
      ];
      # Disable for now
      # boot.kernelParams = [
      #   "i915.force_probe=!*"
      #   "xe.force_probe=*"
      # ];
      # boot.initrd.kernelModules = [ "xe" ];
    })
  ];
}