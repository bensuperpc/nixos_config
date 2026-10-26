{ pkgs, ... }:
{
  microvm = {
    vcpu = 2;
    mem = 1024;
    shares = [
    ];
    interfaces = [
      {
        type = "user";
        id = "usernet0";
        mac = "02:00:00:00:00:02";
      }
    ];
    forwardPorts = [
      {
        from = "host";
        host.address = "127.0.0.1";
        host.port = 2222;
        guest.port = 22;
      }
      {
        from = "host";
        # host.address = "127.0.0.1";
        host.port = 8080;
        guest.port = 80;
      }
    ];
    volumes = [
      {
        image = "docker-data.img";
        mountPoint = "/var/lib/docker";
        size = 8192;
        direct = true;
      }
    ];
  };

  networking.firewall.allowedTCPPorts = [ 80 ];

  virtualisation = {
    containers.enable = true;
    docker = {
      enable = true;
      enableOnBoot = true;
      autoPrune = {
        randomizedDelaySec = "45min";
        enable = true;
        dates = "weekly";
      };
    };
    oci-containers = {
      backend = "docker";
      containers = import ./containers.nix { inherit pkgs; };
    };
  };
}
