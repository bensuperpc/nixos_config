{ pkgsSets }:

let
  containers = import ./containers.nix { pkgs = pkgsSets.stable-2605; };
in
{
  microvm-net = {
    autostart = true;
    restartIfChanged = true;
    pkgs = pkgsSets.stable-2605;
    config =
      { lib, pkgs, ... }:
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
              size = 16384;
              direct = true;
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
            inherit containers;
          };
        };
      };
  };
}
