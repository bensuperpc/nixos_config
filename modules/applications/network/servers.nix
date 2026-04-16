{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.webServers;

  corePackages = with pkgs; [
    nginx
    caddy
  ];

  reverseProxyPackages = with pkgs; [
    traefik
    haproxy
  ];

  enabledOptionalsPackages =
    lib.optionals cfg.core corePackages
    ++ lib.optionals cfg.reverseProxy reverseProxyPackages;

  anyPackagesEnabled = lib.any (x: x) [
    cfg.core
    cfg.reverseProxy
  ];
in
{
  options.myConfig.apps.webServers = {
    core = moduleHelpers.mkDisabledOption "Install Nginx and Caddy web servers";
    reverseProxy = moduleHelpers.mkDisabledOption "Install reverse proxy servers (Traefik, HAProxy)";

    nginxService = moduleHelpers.mkDisabledOption "Enable the Nginx system service";
    caddyService = moduleHelpers.mkDisabledOption "Enable the Caddy system service";
    traefikService = moduleHelpers.mkDisabledOption "Enable the Traefik system service";
    haproxyService = moduleHelpers.mkDisabledOption "Enable the HAProxy system service";
  };

  config = lib.mkMerge [
    (lib.mkIf anyPackagesEnabled {
      environment.systemPackages = enabledOptionalsPackages;
    })

    (lib.mkIf cfg.nginxService {
      services.nginx.enable = true;
    })

    (lib.mkIf cfg.caddyService {
      services.caddy.enable = true;
    })

    (lib.mkIf cfg.traefikService {
      services.traefik.enable = true;
    })

    (lib.mkIf cfg.haproxyService {
      services.haproxy.enable = true;
    })
  ];
}
