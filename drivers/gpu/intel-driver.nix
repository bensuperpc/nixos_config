# More info: https://wiki.nixos.org/wiki/Intel_Graphics
{ pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:

{
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # For Broadwell (2014) or newer processors. LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # For older processors. LIBVA_DRIVER_NAME=i965
      vpl-gpu-rt
      libvdpau-va-gl
      # For Arc/Xe GPU support
      intel-compute-runtime
    ];
  };
  # environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };

  environment.systemPackages = with pkgs; [
    intel-gpu-tools
    mesa
  ];
}