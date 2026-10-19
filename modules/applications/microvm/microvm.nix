{
  config,
  lib,
  moduleHelpers,
  pkgsSets,
  ...
}:

let
  cfg = config.myConfig.apps.microvm;

  vmDescriptions = {
    dockerTest = "Test VM running Docker containers.";
  };

  enabledVms = lib.filter (name: cfg.vms.${name}) (lib.attrNames vmDescriptions);

  mkVm = name: {
    autostart = true;
    restartIfChanged = true;
    pkgs = pkgsSets.stable-2605;
    config.imports = [
      ./vm/common.nix
      ./vm/${name}/main.nix
      {
        networking.hostName = name;
        users.users.root.openssh.authorizedKeys.keys = cfg.authorizedKeys;
        microvm.credentialFiles.root-password-hash =
          config.sops.secrets."microvm/${name}/root-password".path;
      }
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

    vms = lib.mapAttrs (_: moduleHelpers.mkDisabledOption) vmDescriptions;
  };

  config = lib.mkMerge [
    {
      microvm.host.enable = cfg.host;
      microvm.vms = lib.genAttrs enabledVms mkVm;

      sops.secrets = lib.genAttrs' enabledVms (
        name: lib.nameValuePair "microvm/${name}/root-password" { owner = "microvm"; }
      );
    }
    (lib.mkIf cfg.host {
      myConfig.system.impermanence.persistDirectories = [ "/var/lib/microvms" ];
    })
    (lib.mkIf cfg.vms.dockerTest {
      networking.firewall.allowedTCPPorts = [
        8080
      ];
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
