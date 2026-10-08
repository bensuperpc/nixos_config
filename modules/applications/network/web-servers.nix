{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.network.servers;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      core = {
        description = "Install Nginx and Caddy web servers";
        packages = with pkgs; [
          nginx
          caddy
        ];
      };
      reverseProxy = {
        description = "Install reverse proxies and protocol multiplexers (Traefik, HAProxy, sslh)";
        packages = with pkgs; [
          traefik
          haproxy
          sslh
        ];
      };
    };
  };
in
{
  options.myConfig.apps.network.servers = generated.options // {
    services = {
      nginx = moduleHelpers.mkDisabledOption "Enable the Nginx system service";
      caddy = moduleHelpers.mkDisabledOption "Enable the Caddy system service";
      traefik = moduleHelpers.mkDisabledOption "Enable the Traefik system service";
      haproxy = moduleHelpers.mkDisabledOption "Enable the HAProxy system service";
    };
  };

  config = lib.mkMerge [
    generated.config
    {
      services = {
        nginx.enable = lib.mkIf cfg.services.nginx true;
        caddy.enable = lib.mkIf cfg.services.caddy true;
        traefik.enable = lib.mkIf cfg.services.traefik true;
        haproxy.enable = lib.mkIf cfg.services.haproxy true;
      };

      myConfig.system.impermanence.persistDirectories = lib.mkIf cfg.services.caddy [ "/var/lib/caddy" ];
    }
  ];
}
