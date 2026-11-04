{
  config,
  lib,
  moduleHelpers,
  pkgsSets,
  ...
}:

let
  cfg = config.myConfig.apps.microvm;

  mkVm =
    {
      vmName,
      ip,
      mac,
      credentials ? { },
    }:
    {
      autostart = true;
      restartIfChanged = true;
      pkgs = pkgsSets.stable-2605;
      config.imports = [
        ./vm/common.nix
        { _module.args = { inherit vmName ip mac; }; }
        ./vm/${vmName}/main.nix
        {
          users.users.root.openssh.authorizedKeys.keys = cfg.authorizedKeys;
          microvm.credentialFiles = credentials;
        }
      ];
    };

  # The guest's /var/lib must be root-owned from the first boot, or systemd-tmpfiles refuses to chown below it.
  rootOwnedDir.d = lib.mapAttrs (_: lib.mkForce) {
    user = "root";
    group = "root";
    mode = "0755";
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
      edge = moduleHelpers.mkDisabledOption "Caddy reverse proxy, exposed on 80/443.";
      auth = moduleHelpers.mkDisabledOption "Authelia SSO, reachable from edge only.";
      torrent = moduleHelpers.mkDisabledOption "qBittorrent, web UI reachable from edge only.";
    };
  };

  config = lib.mkMerge [
    {
      microvm.host.enable = cfg.host;

      assertions = [
        {
          assertion = config.microvm.vms == { } || cfg.host;
          message = "myConfig.apps.microvm.vms.* require myConfig.apps.microvm.host = true.";
        }
      ];
    }

    (lib.mkIf cfg.host {
      myConfig.system.impermanence.persistDirectories = [ "/var/lib/microvms" ];
    })

    (lib.mkIf cfg.vms.edge {
      microvm.vms.edge = mkVm {
        vmName = "edge";
        ip = "10.0.0.1";
        mac = "02:00:00:00:00:01";
      };

      systemd = {
        network.networks."30-vm-edge" = {
          matchConfig.Name = "vm-edge";
          address = [ "10.0.0.254/32" ];
          routes = [ { Destination = "10.0.0.1/32"; } ];
        };
        tmpfiles.settings."10-microvm"."/var/lib/microvms/edge/var-lib" = rootOwnedDir;
      };

      networking.nftables.tables.microvm-edge = {
        family = "ip";
        content = ''
          chain prerouting {
            type nat hook prerouting priority dstnat; policy accept;
            iifname != "lo" iifname != "vm-*" fib daddr type local tcp dport { 80, 443 } dnat to 10.0.0.1
            iifname != "lo" iifname != "vm-*" fib daddr type local udp dport 443 dnat to 10.0.0.1
          }
        '';
      };
    })

    (lib.mkIf cfg.vms.auth {
      microvm.vms.auth = mkVm {
        vmName = "auth";
        ip = "10.0.0.3";
        mac = "02:00:00:00:00:03";
        credentials = {
          authelia-jwt = config.sops.secrets."microvm/auth/authelia-jwt".path;
          authelia-storage = config.sops.secrets."microvm/auth/authelia-storage".path;
          authelia-users = config.sops.secrets."microvm/auth/authelia-users".path;
        };
      };

      sops.secrets = {
        "microvm/auth/authelia-jwt".owner = "microvm";
        "microvm/auth/authelia-storage".owner = "microvm";
        "microvm/auth/authelia-users".owner = "microvm";
      };

      systemd = {
        network.networks."30-vm-auth" = {
          matchConfig.Name = "vm-auth";
          address = [ "10.0.0.254/32" ];
          routes = [ { Destination = "10.0.0.3/32"; } ];
        };
        tmpfiles.settings."10-microvm"."/var/lib/microvms/auth/var-lib" = rootOwnedDir;
      };
    })

    (lib.mkIf cfg.vms.torrent {
      microvm.vms.torrent = mkVm {
        vmName = "torrent";
        ip = "10.0.0.2";
        mac = "02:00:00:00:00:02";
      };

      systemd = {
        network.networks."30-vm-torrent" = {
          matchConfig.Name = "vm-torrent";
          address = [ "10.0.0.254/32" ];
          routes = [ { Destination = "10.0.0.2/32"; } ];
        };
        tmpfiles.settings."10-microvm"."/var/lib/microvms/torrent/var-lib" = rootOwnedDir;
        tmpfiles.rules = [ "h /var/lib/microvms/torrent/var-lib - - - - +C" ];
      };

      networking.nftables.tables.microvm-torrent = {
        family = "ip";
        content = ''
          chain prerouting {
            type nat hook prerouting priority dstnat; policy accept;
            iifname != "lo" iifname != "vm-*" fib daddr type local tcp dport 6881 dnat to 10.0.0.2
            iifname != "lo" iifname != "vm-*" fib daddr type local udp dport 6881 dnat to 10.0.0.2
          }
        '';
      };
    })

    (lib.mkIf (cfg.vms.edge || cfg.vms.auth || cfg.vms.torrent) {
      networking.networkmanager.unmanaged = [ "interface-name:vm-*" ];

      systemd.network = {
        enable = true;
        wait-online.enable = false;
      };

      # Also set by the docker module: when forwarding is already on at boot, Docker keeps the FORWARD policy at accept.
      boot.kernel.sysctl."net.ipv4.conf.all.forwarding" = true;

      networking.nftables.tables = {
        microvm-nat = {
          family = "ip";
          content = ''
            chain postrouting {
              type nat hook postrouting priority srcnat; policy accept;
              ip saddr 10.0.0.0/24 ip daddr != 10.0.0.0/24 masquerade
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
              iifname "vm-edge" oifname "vm-auth" tcp dport 9091 accept
              iifname "vm-edge" oifname "vm-torrent" tcp dport 8080 accept
              oifname "vm-*" drop
              iifname "vm-*" ip daddr { 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16, 100.64.0.0/10, 169.254.0.0/16 } drop
            }
          '';
        };
      };
    })
  ];
}
