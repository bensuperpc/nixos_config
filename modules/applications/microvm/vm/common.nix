{
  vmName,
  ip,
  mac,
  ...
}:
{
  system.stateVersion = "26.05";

  microvm = {
    hypervisor = "qemu";
    interfaces = [
      {
        type = "tap";
        id = "vm-${vmName}";
        inherit mac;
      }
    ];
    shares = [
      {
        source = "/var/lib/microvms/${vmName}/var-lib";
        mountPoint = "/var/lib";
        tag = "var-lib";
        proto = "virtiofs";
        # Drop --xattr/--posix-acl: shrinks the virtiofsd protocol surface. /var/lib needs neither.
        posixAcl = false;
      }
    ];
  };

  # Users and groups are allocated in /var/lib/nixos during activation, before systemd mounts the other shares.
  fileSystems."/var/lib".neededForBoot = true;

  networking = {
    hostName = vmName;
    useDHCP = false;
    useNetworkd = true;
    nameservers = [
      "9.9.9.9"
      "149.112.112.112"
    ];
    hosts = {
      "10.0.0.1" = [ "edge" ];
      "10.0.0.2" = [ "torrent" ];
      "10.0.0.3" = [ "auth" ];
    };
    nftables.enable = true;
    firewall.extraInputRules = ''
      ip saddr 10.0.0.254 tcp dport 22 accept
    '';
  };

  systemd.network.networks."10-uplink" = {
    matchConfig.MACAddress = mac;
    address = [ "${ip}/32" ];
    routes = [
      {
        Destination = "10.0.0.254/32";
        GatewayOnLink = true;
      }
      {
        Destination = "0.0.0.0/0";
        Gateway = "10.0.0.254";
        GatewayOnLink = true;
      }
    ];
  };

  services.openssh = {
    enable = true;
    openFirewall = false;
    hostKeys = [
      {
        path = "/var/lib/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  boot.initrd.availableKernelModules = [ "qemu_fw_cfg" ];
}
