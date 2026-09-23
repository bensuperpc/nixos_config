# Intel Skylake mini PC (Lenovo M710q), full role.

_: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./disko.nix
  ];

  myConfig.apps.microvm.examples.test = true;

  # Don't touch that unless you know what you're doing!
  system.stateVersion = "26.05"; # Did you read the comment?
}
