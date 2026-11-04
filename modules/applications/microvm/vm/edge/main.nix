_:
let
  domain = "bensuperpc.org";
  credential = name: "/run/credentials/authelia-main.service/${name}";

  securityHeaders = ''
    header {
      Strict-Transport-Security "max-age=31536000; includeSubDomains"
      X-Content-Type-Options "nosniff"
      X-Frame-Options "DENY"
      Referrer-Policy "strict-origin-when-cross-origin"
      Permissions-Policy "geolocation=(), camera=(), microphone=(), usb=()"
      Cross-Origin-Opener-Policy "same-origin"
      -Server
    }
  '';

  autheliaGate = ''
    forward_auth 127.0.0.1:9091 {
      uri /api/authz/forward-auth
      copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
    }
  '';

  vhost = extraConfig: {
    inherit extraConfig;
    logFormat = "output stderr";
  };
in
{
  microvm = {
    vcpu = 2;
    mem = 1024;
  };

  services.caddy = {
    enable = true;
    virtualHosts = {
      "authelia.${domain}" = vhost ''
        ${securityHeaders}
        reverse_proxy 127.0.0.1:9091
      '';

      "torrent.${domain}" = vhost ''
        ${securityHeaders}
        ${autheliaGate}
        header Cache-Control "no-store"
        reverse_proxy torrent:8080 {
          header_up Referer "https://torrent.${domain}"
        }
      '';

      "qbittorrent.${domain}" = vhost ''
        redir https://torrent.${domain}{uri} permanent
      '';
    };
  };

  services.authelia.instances.main = {
    enable = true;
    secrets = {
      jwtSecretFile = credential "jwt";
      storageEncryptionKeyFile = credential "storage";
    };
    settings = {
      theme = "auto";
      server.address = "tcp://127.0.0.1:9091/";
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
