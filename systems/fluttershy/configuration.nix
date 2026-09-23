# Intel Skylake headless server.

{ ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./disko.nix
  ];

  # Don't touch that unless you know what you're doing!
  system.stateVersion = "26.05"; # Did you read the comment?
}
