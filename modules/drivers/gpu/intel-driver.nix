# More info: https://wiki.nixos.org/wiki/Intel_Graphics
{ config, lib, pkgs, ... }:

let
  cfg = config.myConfig.drivers.gpu.intel;
  oldEnabled = cfg.enableOldDriver;
  skylakeEnabled = cfg.enableSkylakeDriver;
  xeEnabled = cfg.enableXeDriver;
  anyEnabled = oldEnabled || skylakeEnabled || xeEnabled;
in
{
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

    (lib.mkIf oldEnabled {
      hardware.graphics.extraPackages = with pkgs; [
        intel-vaapi-driver
      ];
    })

    (lib.mkIf skylakeEnabled {
      hardware.graphics.extraPackages = with pkgs; [
        intel-media-driver
        intel-compute-runtime-legacy1
      ];
    })

    (lib.mkIf xeEnabled {
      hardware.graphics.extraPackages = with pkgs; [
        intel-media-driver
        vpl-gpu-rt
        intel-compute-runtime
      ];

      boot.kernelParams = [
        "i915.force_probe=!*"
        "xe.force_probe=*"
      ];
      boot.initrd.kernelModules = [ "xe" ];
    })
  ];
}