{
  config,
  lib,
  moduleHelpers,
  pkgsSets,
  varsHost,
  ...
}:

let
  cfg = config.myConfig.apps.microvm;
  dockerTest = import ./vm/dockerTest/main.nix { inherit pkgsSets; };
  anyExampleEnabled = cfg.examples.test;
  secretsEnabled = config.myConfig.system.secrets.enable;
in
{
  options.myConfig.apps.microvm = {
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
      microvm.vms = dockerTest;
      # networking.firewall.allowedTCPPorts = [
      #   8080
      # ];

      sops.secrets."microvm/dockerTest/root-password" = {
        sopsFile = ../../../secrets/hosts/${varsHost.name}.yaml;
        path = "/srv/microvm-shared/microvm-shared/root-password-hash";
        mode = "0444";
      };

      assertions = [
        {
          assertion = secretsEnabled;
          message = "myConfig.apps.microvm.examples.test needs sops secrets (myConfig.system.secrets.enable = true).";
        }
      ];
    })
    (lib.mkIf anyExampleEnabled {
      assertions = [
        {
          assertion = cfg.host;
          message = "myConfig.apps.microvm.examples.* require myConfig.apps.microvm.host = true;";
        }
      ];
    })
  ];
}
