{
  config,
  lib,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.utilities.microvm;
  roStoreShare = {
    source = "/nix/store";
    mountPoint = "/nix/.ro-store";
    tag = "ro-store";
    proto = "virtiofs";
    readOnly = true;
  };
  networkedVm = {
    microvm-net = {
      autostart = true;
      config =
        { lib, ... }:
        {
          networking.hostName = "microvm-net";
          system.stateVersion = lib.trivial.release;

          microvm = {
            vcpu = 1;
            mem = 512;
            hypervisor = "qemu";
            shares = [
              roStoreShare
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

          services.nginx = {
            enable = true;
            virtualHosts."_" = {
              default = true;
              locations."/".return = "200 'microvm-net is up'";
            };
          };
        };
    };
  };
  anyExampleEnabled = cfg.examples.test;
in
{
  options.myConfig.apps.utilities.microvm = {
    host = moduleHelpers.mkDisabledOption "Enable the MicroVM host service (microvm-host)";

    examples = {
      test = moduleHelpers.mkDisabledOption "Test the MicroVM host service with a networked VM";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.host {
      microvm.host.enable = true;
    })
    (lib.mkIf cfg.examples.test {
      microvm.vms = networkedVm;
      # networking.firewall.allowedTCPPorts = [
      #   8080
      # ];
    })
    (lib.mkIf anyExampleEnabled {
      assertions = [
        {
          assertion = cfg.host;
          message = "myConfig.apps.utilities.microvm.examples.* require myConfig.apps.utilities.microvm.host = true;";
        }
      ];
    })
  ];
}
