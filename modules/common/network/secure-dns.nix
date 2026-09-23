{
  config,
  lib,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.system.secureDns;
in
{
  options.myConfig.system.secureDns = {
    enable = moduleHelpers.mkEnabledOption "local DNS resolver (unbound) forwarding to DoH through dnscrypt-proxy";

    localData = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ''"mabox. IN A 192.168.1.1"'' ];
      description = "Static unbound `local-data` records (already quoted, unbound syntax).";
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      resolved.enable = false;

      dnscrypt-proxy = {
        enable = true;
        settings = {
          listen_addresses = [
            "127.0.0.1:5353"
            "[::1]:5353"
          ];

          doh_servers = true;
          dnscrypt_servers = false;

          server_names = [
            "cloudflare"
            "quad9-doh-ip4-port443-filter-pri"
          ];

          require_dnssec = true;
          require_nolog = true;
        };
      };

      unbound = {
        enable = true;
        settings = {
          server = {
            interface = [
              "127.0.0.1"
              "::1"
            ];
            port = 53;
            do-not-query-localhost = "no";

            prefetch = "yes";
            cache-min-ttl = 900;
            cache-max-ttl = 86400;
            serve-expired = "yes";
            local-data = cfg.localData;
          };

          forward-zone = [
            {
              name = ".";
              forward-addr = [
                "127.0.0.1@5353"
                "::1@5353"
              ];
            }
          ];
        };
      };
    };

    networking = {
      nameservers = [
        "127.0.0.1"
        "::1"
      ];

      networkmanager = {
        dns = "none";

        settings.connection = {
          "ipv4.ignore-auto-dns" = true;
          "ipv6.ignore-auto-dns" = true;
        };
      };
    };
  };
}
