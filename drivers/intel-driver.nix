# More info: https://wiki.nixos.org/wiki/Intel_Graphics
{ pkgs, inputs, vars, ... }:

{
  hardware.enableRedistributableFirmware = true;
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      vpl-gpu-rt
      libvdpau-va-gl
      # For Arc/Xe GPU support
      intel-compute-runtime
    ];
  };
}