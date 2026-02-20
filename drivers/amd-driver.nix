# More info: https://wiki.nixos.org/wiki/AMD_GPU
{ pkgs, inputs, vars, ... }:

{
  hardware.enableRedistributableFirmware = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      # For older AMD GPUs
      #mesa.opencl
    ];
  };
  boot.kernelParams = [
    # For Sea Islands (CIK i.e. GCN 1) cards
    "amdgpu.cik_support=1"
    "radeon.cik_support=0"
];
}