# My NixOS test server configuration.

{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./../../drivers/gpu/intel-driver.nix
      ./../../drivers/bluetooth.nix
    ];

  # Don't touch that unless you know what you're doing!
  system.stateVersion = "25.11"; # Did you read the comment?
}
