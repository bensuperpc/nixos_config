{
  config,
  lib,
  moduleHelpers,
  pkgsSets,
  ...
}:

let
  cfg = config.myConfig.apps.microvm;

  mkVm = name: {
    autostart = true;
    restartIfChanged = true;
    pkgs = pkgsSets.stable-2605;
    config.imports = [
      (import ./vm/common.nix {
        inherit name;
        inherit (cfg) authorizedKeys;
        passwordHashFile = config.sops.secrets."microvm/${name}/root-password".path;
      })
      ./vm/${name}/main.nix
    ];
  };
in
{
  options.myConfig.apps.microvm = {
    host = moduleHelpers.mkDisabledOption "Enable the MicroVM host service (microvm-host)";

    authorizedKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "SSH public keys allowed to log in as root on the MicroVMs.";
    };

    vms = {
      dockerTest = moduleHelpers.mkDisabledOption "Test VM running Docker containers.";
    };
  };

  config = lib.mkMerge [
    {
      microvm.host.enable = cfg.host;
    }
    (lib.mkIf cfg.host {
      myConfig.system.impermanence.persistDirectories = [ "/var/lib/microvms" ];
    })
    (lib.mkIf cfg.vms.dockerTest {
      microvm.vms.dockerTest = mkVm "dockerTest";

      sops.secrets."microvm/dockerTest/root-password".owner = "microvm";
      # networking.firewall.allowedTCPPorts = [
      #   8080
      # ];
    })
    {
      assertions = [
        {
          assertion = config.microvm.vms == { } || cfg.host;
          message = "myConfig.apps.microvm.vms.* require myConfig.apps.microvm.host = true.";
        }
      ];
    }
  ];
}
