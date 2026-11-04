_:
let
  domain = "bensuperpc.org";

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
    forward_auth auth:9091 {
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

  networking.firewall = {
    allowedTCPPorts = [
      80
      443
    ];
    allowedUDPPorts = [ 443 ];
  };

  services.caddy = {
    enable = true;
    virtualHosts = {
      "authelia.${domain}" = vhost ''
        ${securityHeaders}
        reverse_proxy auth:9091
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
}
