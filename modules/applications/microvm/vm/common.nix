{
  lib,
  vmName,
  vms,
  hostIp,
  ipOf,
  ...
}:
let
  vm = vms.${vmName};
  mac = "02:00:00:00:00:${lib.fixedWidthString 2 "0" (lib.toHexString vm.index)}";
  ports = lib.concatMapStringsSep ", " toString;
in
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
    hosts = lib.mapAttrs' (name: _: lib.nameValuePair (ipOf name) [ name ]) vms;
    nftables.enable = true;
    firewall = {
      allowedTCPPorts = vm.tcp;
      allowedUDPPorts = vm.udp;
      extraInputRules = ''
        ip saddr ${hostIp} tcp dport 22 accept
      ''
      + lib.concatStrings (
        lib.mapAttrsToList (from: allowed: ''
          ip saddr ${ipOf from} tcp dport { ${ports allowed} } accept
        '') vm.fromVms
      );
    };
  };

  systemd.network.networks."10-uplink" = {
    matchConfig.MACAddress = mac;
    address = [ "${ipOf vmName}/32" ];
    routes = [
      {
        Destination = "${hostIp}/32";
        GatewayOnLink = true;
      }
      {
        Destination = "0.0.0.0/0";
        Gateway = hostIp;
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
