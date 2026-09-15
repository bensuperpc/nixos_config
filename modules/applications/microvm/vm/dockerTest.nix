{
  microvm-net = {
    autostart = true;
    config =
      { lib, pkgs, ... }:
      let
        indexHtml = pkgs.writeText "index.html" "microvm-net is up";
      in
      {
        networking.hostName = "microvm-net";
        system.stateVersion = lib.trivial.release;

        microvm = {
          vcpu = 2;
          mem = 1024;
          hypervisor = "qemu";
          shares = [
            {
              source = "/nix/store";
              mountPoint = "/nix/.ro-store";
              tag = "ro-store";
              proto = "virtiofs";
              readOnly = true;
            }
            {
              source = "/srv/microvm-shared/microvm-shared";
              mountPoint = "/mnt/shared";
              tag = "shared";
              proto = "virtiofs";
            }
          ];
          writableStoreOverlay = "/nix/.rw-store";
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
              host.port = 8080;
              guest.port = 80;
            }
          ];
          volumes = [
            {
              image = "nix-store-overlay.img";
              mountPoint = "/nix/.rw-store";
              size = 2048;
            }
            {
              image = "docker-data.img";
              mountPoint = "/var/lib/docker";
              size = 8192;
              direct = true;
            }
          ];
        };

        networking.firewall.allowedTCPPorts = [
          22
          80
        ];

        services.openssh = {
          enable = true;
          settings.PermitRootLogin = "yes";
        };
        users.users.root.initialPassword = "microvm";

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
            containers.caddy = {
              autoStart = true;
              # readOnly = true;
              image = "caddy:alpine";
              ports = [ "80:80" ];
              volumes = [
                "${indexHtml}:/usr/share/caddy/index.html:ro"
                # "caddy_data:/data"
                # "caddy_config:/config"
              ];
              capabilities = {
                NET_BIND_SERVICE = true;
                # CAP_DAC_OVERRIDE = true;
                # CAP_NET_RAW = true;
                ALL = false;
              };
            };
          };
        };
      };
  };
}
