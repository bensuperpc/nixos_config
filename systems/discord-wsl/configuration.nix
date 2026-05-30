# My NixOS test server configuration.

{ config, lib, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  networking.hostName = "discord-wsl";

  wsl.defaultUser = "bensuperpc";

  # Don't touch that unless you know what you're doing!
  system.stateVersion = "26.05"; # Did you read the comment?
}
