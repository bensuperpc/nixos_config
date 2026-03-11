# My NixOS test server configuration.

{ config, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, vars, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./../../drivers/gpu/intel-driver.nix
    ];

  # Don't touch that unless you know what you're doing!
  system.stateVersion = "25.11"; # Did you read the comment?
}
