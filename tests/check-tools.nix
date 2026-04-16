# tests/check-tools.nix
{ config, pkgs, lib, ... }:

let
  requiredToolsPkgs = with pkgs; [
    wget
    curl
    btop
    tree
    parallel
    cryptsetup
    fastfetch
  ];
in
{
  assertions =
    [
      {
        assertion = config.myConfig.apps.tools.system;
        message = "Tools system group must be enabled";
      }
      {
        assertion = config.myConfig.apps.tools.network;
        message = "Tools network group must be enabled";
      }
      {
        assertion = config.myConfig.apps.tools.cli;
        message = "Tools CLI group must be enabled";
      }
      {
        assertion = config.myConfig.apps.tools.security;
        message = "Tools security group must be enabled";
      }
      {
        assertion = config.myConfig.apps.tools.archive;
        message = "Tools archive group must be enabled";
      }
    ]
    ++ map (pkg: {
      assertion = lib.elem pkg config.environment.systemPackages;
      message = "Package missing: ${pkg.name}";
    }) requiredToolsPkgs;
}