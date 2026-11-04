_:
let
  domain = "bensuperpc.org";
  credential = name: "/run/credentials/authelia-main.service/${name}";
in
{
  microvm = {
    vcpu = 1;
    mem = 512;
  };

  # Only edge (the reverse proxy) may reach Authelia; nothing is exposed to the internet.
  networking.firewall.extraInputRules = ''
    ip saddr 10.0.0.1 tcp dport 9091 accept
  '';

  services.authelia.instances.main = {
    enable = true;
    secrets = {
      jwtSecretFile = credential "jwt";
      storageEncryptionKeyFile = credential "storage";
    };
    settings = {
      theme = "auto";
      server.address = "tcp://0.0.0.0:9091/";
      log.level = "info";
      totp.issuer = domain;

      authentication_backend = {
        file.path = credential "users";
        password_reset.disable = true;
        password_change.disable = true;
      };

      access_control = {
        default_policy = "deny";
        rules = [
          {
            domain = "torrent.${domain}";
            subject = "group:admins";
            policy = "one_factor";
          }
        ];
      };

      session.cookies = [
        {
          inherit domain;
          authelia_url = "https://authelia.${domain}";
        }
      ];

      regulation = {
        max_retries = 5;
        find_time = "10m";
        ban_time = "1h";
      };

      storage.local.path = "/var/lib/authelia-main/db.sqlite3";
      notifier.filesystem.filename = "/var/lib/authelia-main/notification.txt";
    };
  };

  systemd.services.authelia-main.serviceConfig.LoadCredential =
    map (name: "${name}:/run/credentials/@system/authelia-${name}")
      [
        "jwt"
        "storage"
        "users"
      ];
}
