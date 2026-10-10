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
  dockerTest = import ./vm/dockerTest/main.nix {
    inherit pkgsSets;
    authorizedKeys = config.users.users.${varsHost.deployUser}.openssh.authorizedKeys.keys;
    passwordSecret = config.sops.secrets."microvm/dockerTest/root-password";
  };
in
{
  options.myConfig.apps.microvm = {
    host = moduleHelpers.mkDisabledOption "Enable the MicroVM host service (microvm-host)";

    examples = {
      test = moduleHelpers.mkDisabledOption "Test the MicroVM host service with a networked VM.";
    };
  };

  config = lib.mkMerge [
    {
      microvm.host.enable = cfg.host;
    }
    (lib.mkIf cfg.host {
      myConfig.system.impermanence.persistDirectories = [ "/var/lib/microvms" ];
    })
    (lib.mkIf cfg.examples.test {
      microvm.vms = dockerTest;

      sops.secrets."microvm/dockerTest/root-password".owner = "microvm";

      assertions = [
        {
          assertion = cfg.host;
          message = "myConfig.apps.microvm.examples.* require myConfig.apps.microvm.host = true.";
        }
      ];
    })
  ];
}
