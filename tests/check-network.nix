# tests/check-network.nix
{ config, pkgs, lib, ... }:

let
  requiredNetworkingToolsPkgs = with pkgs; [
    wireshark
    openvpn
  ];

  requiredWebServersCorePkgs = with pkgs; [
    caddy
    nginx
  ];

  requiredWebServersReverseProxyPkgs = with pkgs; [
    traefik
    haproxy
  ];
in
{
  assertions =
    [
      {
        assertion = config.myConfig.apps.networkingTools.tooling;
        message = "Networking tools group must be enabled";
      }
      {
        assertion = config.myConfig.apps.webServers.core;
        message = "Web servers core group must be enabled";
      }
      {
        assertion = config.myConfig.apps.webServers.reverseProxy;
        message = "Web servers reverse proxy group must be enabled";
      }
    ]
    ++ lib.optionals config.myConfig.apps.networkingTools.tooling (
      map (pkg: {
        assertion = lib.elem pkg config.environment.systemPackages;
        message = "Package missing: ${pkg.name}";
      }) requiredNetworkingToolsPkgs
    )
    ++ lib.optionals config.myConfig.apps.webServers.core (
      map (pkg: {
        assertion = lib.elem pkg config.environment.systemPackages;
        message = "Package missing: ${pkg.name}";
      }) requiredWebServersCorePkgs
    )
    ++ lib.optionals config.myConfig.apps.webServers.reverseProxy (
      map (pkg: {
        assertion = lib.elem pkg config.environment.systemPackages;
        message = "Package missing: ${pkg.name}";
      }) requiredWebServersReverseProxyPkgs
    );
}