{
  config,
  lib,
  moduleHelpers,
  pkgsSets,
  ...
}:

let
  cfg = config.myConfig.apps.microvm;

  # index: last byte of the VM IP and MAC. tcp/udp: ports forwarded from the host. fromVms: VM-to-VM access.
  vms = {
    edge = {
      description = "Caddy reverse proxy and Authelia SSO, exposed on 80/443.";
      index = 1;
      tcp = [
        80
        443
      ];
      udp = [ 443 ];
      fromVms = { };
      credentials = [
        "authelia-jwt"
        "authelia-storage"
        "authelia-users"
      ];
    };
    torrent = {
      description = "qBittorrent, web UI reachable from edge only.";
      index = 2;
      tcp = [ 6881 ];
      udp = [ 6881 ];
      fromVms.edge = [ 8080 ];
      credentials = [ ];
    };
  };

  net = "10.0.0";
  hostIp = "${net}.254";
  ipOf = name: "${net}.${toString vms.${name}.index}";

  enabledVms = lib.filter (vmName: cfg.vms.${vmName}) (lib.attrNames vms);

  ports = lib.concatMapStringsSep ", " toString;

  mkVm = vmName: {
    autostart = true;
    restartIfChanged = true;
    pkgs = pkgsSets.stable-2605;
    config.imports = [
      ./vm/common.nix
      {
        _module.args = {
          inherit
            vmName
            vms
            hostIp
            ipOf
            ;
        };
      }
      ./vm/${vmName}/main.nix
      {
        users.users.root.openssh.authorizedKeys.keys = cfg.authorizedKeys;
        microvm.credentialFiles = lib.genAttrs vms.${vmName}.credentials (
          cred: config.sops.secrets."microvm/${vmName}/${cred}".path
        );
      }
    ];
  };

  dnatRules = lib.concatMapStrings (
    vmName:
    lib.concatMapStrings
      (
        proto:
        lib.optionalString (vms.${vmName}.${proto} != [ ]) ''
          iifname != "lo" iifname != "vm-*" fib daddr type local ${proto} dport { ${ports vms.${vmName}.${proto}} } dnat to ${ipOf vmName}
        ''
      )
      [
        "tcp"
        "udp"
      ]
  ) enabledVms;

  vmToVmRules = lib.concatMapStrings (
    vmName:
    lib.concatStrings (
      lib.mapAttrsToList (from: allowed: ''
        iifname "vm-${from}" oifname "vm-${vmName}" tcp dport { ${ports allowed} } accept
      '') vms.${vmName}.fromVms
    )
  ) enabledVms;
in
{
  options.myConfig.apps.microvm = {
    host = moduleHelpers.mkDisabledOption "Enable the MicroVM host service (microvm-host)";

    authorizedKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "SSH public keys allowed to log in as root on the MicroVMs.";
    };

    vms = lib.mapAttrs (_: vm: moduleHelpers.mkDisabledOption vm.description) vms;
  };

  config = lib.mkMerge [
    {
      microvm.host.enable = cfg.host;
      microvm.vms = lib.genAttrs enabledVms mkVm;

      sops.secrets = lib.listToAttrs (
        lib.concatMap (
          vmName:
          map (
            cred: lib.nameValuePair "microvm/${vmName}/${cred}" { owner = "microvm"; }
          ) vms.${vmName}.credentials
        ) enabledVms
      );

      assertions = [
        {
          assertion = config.microvm.vms == { } || cfg.host;
          message = "myConfig.apps.microvm.vms.* require myConfig.apps.microvm.host = true.";
        }
        {
          assertion = lib.allUnique (map (vm: vm.index) (lib.attrValues vms));
          message = "microvm: two VMs share the same index (IP and MAC).";
        }
      ];
    }
    (lib.mkIf cfg.host {
      myConfig.system.impermanence.persistDirectories = [ "/var/lib/microvms" ];
    })
    (lib.mkIf (enabledVms != [ ]) {
      networking.networkmanager.unmanaged = [ "interface-name:vm-*" ];

      systemd = {
        network = {
          enable = true;
          wait-online.enable = false;
          networks = lib.listToAttrs (
            map (
              vmName:
              lib.nameValuePair "30-vm-${vmName}" {
                matchConfig.Name = "vm-${vmName}";
                address = [ "${hostIp}/32" ];
                routes = [ { Destination = "${ipOf vmName}/32"; } ];
              }
            ) enabledVms
          );
        };

        # The guest's /var/lib must be root-owned from the first boot, or systemd-tmpfiles refuses to chown below it.
        tmpfiles.settings."10-microvm" = lib.genAttrs' enabledVms (
          vmName:
          lib.nameValuePair "/var/lib/microvms/${vmName}/var-lib" {
            d = lib.mapAttrs (_: lib.mkForce) {
              user = "root";
              group = "root";
              mode = "0755";
            };
          }
        );

        tmpfiles.rules = lib.optional cfg.vms.torrent "h /var/lib/microvms/torrent/var-lib - - - - +C";
      };

      # Also set by the docker module: when forwarding is already on at boot, Docker keeps the FORWARD policy at accept.
      boot.kernel.sysctl."net.ipv4.conf.all.forwarding" = true;

      networking.nftables.tables = {
        microvm-nat = {
          family = "ip";
          content = ''
            chain prerouting {
              type nat hook prerouting priority dstnat; policy accept;
              ${dnatRules}
            }

            chain postrouting {
              type nat hook postrouting priority srcnat; policy accept;
              ip saddr ${net}.0/24 ip daddr != ${net}.0/24 masquerade
            }
          '';
        };

        microvm-filter = {
          family = "inet";
          content = ''
            chain input {
              type filter hook input priority filter; policy accept;
              iifname "vm-*" ct state new drop
            }

            chain forward {
              type filter hook forward priority filter; policy accept;
              ct state { established, related } accept
              oifname "vm-*" ct status dnat accept
              ${vmToVmRules}
              oifname "vm-*" drop
              iifname "vm-*" ip daddr { 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16, 100.64.0.0/10, 169.254.0.0/16 } drop
            }
          '';
        };
      };
    })
  ];
}
