# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:
let
  hardwareConfig = ./hardware-configuration.nix;
in
{
  imports =
    (lib.optional (builtins.pathExists hardwareConfig) hardwareConfig)
    ++ [
      ./../../drivers/gpu/intel-driver.nix
    ];
  # Don't touch that unless you know what you're doing!
  system.stateVersion = "25.11"; # Did you read the comment?
}
