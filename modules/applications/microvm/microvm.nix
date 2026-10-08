{
  config,
  lib,
  moduleHelpers,
  pkgsSets,
  ...
}:

let
  cfg = config.myConfig.apps.microvm;
  dockerTest = import ./vm/dockerTest/main.nix { inherit pkgsSets; };
in
{
  options.myConfig.apps.microvm = {
    host = moduleHelpers.mkDisabledOption "Enable the MicroVM host service (microvm-host)";

    examples = {
      test = moduleHelpers.mkDisabledOption "Test the MicroVM host service with a networked VM (needs microvm/dockerTest/root-password in the host sops file)";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.host {
      myConfig.system.impermanence.persistDirectories = [ "/var/lib/microvms" ];

      microvm.host.enable = true;
    })
    (lib.mkIf cfg.examples.test {
      microvm.vms = dockerTest;

      # From the host sops file (systems/<host>/secrets.yaml, see nixos/secrets.nix).
      sops.secrets."microvm/dockerTest/root-password" = {
        path = "/srv/microvm-shared/microvm-shared/root-password-hash";
        mode = "0444";
      };

      assertions = [
        {
          assertion = cfg.host;
          message = "myConfig.apps.microvm.examples.* require myConfig.apps.microvm.host = true.";
        }
      ];
    })
  ];
}
