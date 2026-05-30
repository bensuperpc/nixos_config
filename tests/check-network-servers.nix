# tests/check-network-servers.nix
{ config, pkgs, lib, ... }:

let
  requiredPkgs = with pkgs; [
    # servers.core
    nginx
    caddy
    # servers.reverseProxy
    traefik
    haproxy
  ];
in
{
  assertions =
    [
      {
        assertion = config.myConfig.apps.network.servers.core;
        message = "Network servers core group must be enabled";
      }
      {
        assertion = config.myConfig.apps.network.servers.reverseProxy;
        message = "Network servers reverse proxy group must be enabled";
      }
    ]
    ++ map (pkg: {
      assertion = lib.elem pkg config.environment.systemPackages;
      message = "Package missing: ${pkg.name}";
    }) requiredPkgs;
}
