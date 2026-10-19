_: {
  system.stateVersion = "26.05";

  microvm = {
    hypervisor = "qemu";
    shares = [
      {
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
        tag = "ro-store";
        proto = "virtiofs";
        readOnly = true;
      }
    ];
    writableStoreOverlay = "/nix/.rw-store";
    volumes = [
      {
        image = "nix-store-overlay.img";
        mountPoint = "/nix/.rw-store";
        size = 16384;
        direct = true;
      }
    ];
  };

  networking.firewall.allowedTCPPorts = [ 22 ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  boot.initrd.availableKernelModules = [ "qemu_fw_cfg" ];

  users.users.root.hashedPasswordFile = "/run/credentials/@system/root-password-hash";
}
