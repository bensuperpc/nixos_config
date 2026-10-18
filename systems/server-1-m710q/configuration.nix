# Intel Skylake mini PC (Lenovo M710q), full role.

_: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./disko.nix
  ];

  myConfig.apps.microvm = {
    vms.dockerTest = true;
    authorizedKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFyA0hju3CFIBjcjtlcNpuTKN+owszgOS8HZ747PDVO6 bensuperpc@server-1-m710q"
    ];
  };

  # Don't touch that unless you know what you're doing!
  system.stateVersion = "26.05"; # Did you read the comment?
}
