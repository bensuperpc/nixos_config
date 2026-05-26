# More info: https://wiki.nixos.org/wiki/AMD_GPU
{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.drivers.gpu.amd;
in
{
  options.myConfig.drivers.gpu.amd.enable = moduleHelpers.mkDisabledOption "Enable AMD GPU driver stack.";

  config = lib.mkIf cfg.enable {
    hardware.graphics = {
      enable = lib.mkDefault true;
      extraPackages = with pkgs; [
        # For older AMD GPUs
        #mesa.opencl
      ];
    };
    boot.kernelParams = [
      # For Sea Islands (CIK i.e. GCN 1) cards
  #    "quiet"
  #    "splash"
  #    "amdgpu.cik_support=1"
  #    "radeon.cik_support=0"
    ];
  };
}