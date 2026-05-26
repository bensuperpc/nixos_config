# More info: https://wiki.nixos.org/wiki/Intel_Graphics
{ config, lib, pkgs, ... }:

let
  variant = config.myConfig.drivers.gpu.intel;
  isIntel  = variant != "none";
in
{
  options.myConfig.drivers.gpu.intel = lib.mkOption {
    type    = lib.types.enum [ "none" "old" "skylake" "xe" ];
    default = "none";
    description = ''
      Intel iGPU driver variant:
        none     - no Intel GPU driver
        old      - iHD/VA-API for Haswell and older
        skylake  - iHD for Skylake to Comet Lake
        xe       - Xe driver for Alder Lake and newer
    '';
  };

  config = lib.mkMerge [
    (lib.mkIf isIntel {
      hardware.graphics = {
        enable      = true;
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

    (lib.mkIf (variant == "old") {
      hardware.graphics.extraPackages = with pkgs; [ intel-vaapi-driver ];
    })

    (lib.mkIf (variant == "skylake") {
      hardware.graphics.extraPackages = with pkgs; [
        intel-media-driver
        intel-compute-runtime-legacy1
      ];
    })

    (lib.mkIf (variant == "xe") {
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