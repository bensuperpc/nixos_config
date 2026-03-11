# tests/check-network.nix
{ config, pkgs, lib, vars, ... }:

let
  requiredNetworkPkgs = with pkgs; [
  ];
in
{
  assertions =
    [
      {
        assertion = config.networking.firewall.enable;
        message = "Firewall must be enabled";
      }
    ]
    ++ map (pkg: {
      assertion = lib.elem pkg config.environment.systemPackages;
      message = "Package missing: ${pkg.name}";
    }) requiredNetworkPkgs;
}