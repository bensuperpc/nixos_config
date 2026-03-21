# More info: https://wiki.nixos.org/wiki/AMD_GPU
{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

{
  hardware.graphics = {
    enable = lib.mkForce true;
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
}