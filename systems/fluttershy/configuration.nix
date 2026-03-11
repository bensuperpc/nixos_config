# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./../../drivers/gpu/intel-driver.nix
    ];
  # Don't touch that unless you know what you're doing!
  system.stateVersion = "25.11"; # Did you read the comment?
}
