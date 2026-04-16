# tests/check-network.nix
{ config, pkgs, lib, ... }:

let
  requiredNetworkCliPkgs = with pkgs; [
    wireshark
    openvpn
  ];

  requiredNetworkServersCorePkgs = with pkgs; [
    caddy
    nginx
  ];

  requiredNetworkServersReverseProxyPkgs = with pkgs; [
    traefik
    haproxy
  ];
in
{
  assertions =
    [
      {
        assertion = config.myConfig.apps.network.cli.tooling;
        message = "Networking tools group must be enabled";
      }
      {
        assertion = config.myConfig.apps.network.servers.core;
        message = "Web servers core group must be enabled";
      }
      {
        assertion = config.myConfig.apps.network.servers.reverseProxy;
        message = "Web servers reverse proxy group must be enabled";
      }
    ]
    ++ lib.optionals config.myConfig.apps.network.cli.tooling (
      map (pkg: {
        assertion = lib.elem pkg config.environment.systemPackages;
        message = "Package missing: ${pkg.name}";
      }) requiredNetworkCliPkgs
    )
    ++ lib.optionals config.myConfig.apps.network.servers.core (
      map (pkg: {
        assertion = lib.elem pkg config.environment.systemPackages;
        message = "Package missing: ${pkg.name}";
      }) requiredNetworkServersCorePkgs
    )
    ++ lib.optionals config.myConfig.apps.network.servers.reverseProxy (
      map (pkg: {
        assertion = lib.elem pkg config.environment.systemPackages;
        message = "Package missing: ${pkg.name}";
      }) requiredNetworkServersReverseProxyPkgs
    );
}