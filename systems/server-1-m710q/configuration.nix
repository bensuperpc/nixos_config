# My NixOS test server configuration.

{ config, lib, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  networking.hostName = "server-1-m710q";

  # Don't touch that unless you know what you're doing!
  system.stateVersion = "25.11"; # Did you read the comment?
}
