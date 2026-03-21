# tests/check-network.nix
{ config, pkgs, lib, vars, ... }:

let
  requiredNetworkPkgs = with pkgs; [
    wireshark
    caddy
    nginx
    openvpn
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
        assertion = config.networking.firewall.enable;
        message = "Firewall must be enabled";
      }
      {
        assertion = config.networking.networkmanager.enable;
        message = "NetworkManager must be enabled";
      }
    ]
    ++ lib.optionals config.myConfig.apps.networkingTools.tooling (
      map (pkg: {
        assertion = lib.elem pkg config.environment.systemPackages;
        message = "Package missing: ${pkg.name}";
      }) requiredNetworkPkgs
    );
}