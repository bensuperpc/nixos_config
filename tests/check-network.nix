# tests/check-network.nix
{ config, pkgs, lib, ... }:

let
  requiredPkgs = with pkgs; [
    wireshark
    openvpn
  ];
in
{
  assertions =
    [
      {
        assertion = config.myConfig.apps.network.cli.tooling;
        message = "Network CLI tooling group must be enabled";
      }
    ]
    ++ map (pkg: {
      assertion = lib.elem pkg config.environment.systemPackages;
      message = "Package missing: ${pkg.name}";
    }) requiredPkgs;
}