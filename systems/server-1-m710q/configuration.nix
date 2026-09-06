# My NixOS test server configuration.

{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./disko.nix
  ];

  networking.hostName = "server-1-m710q";

  # myConfig.system.impermanence = {
  #   enable = true;
  # };

  # Don't touch that unless you know what you're doing!
  system.stateVersion = "26.05"; # Did you read the comment?
}
