# tests/check-tools.nix
{
  config,
  pkgs,
  lib,
  ...
}:

let
  requiredToolsPkgs = with pkgs; [
    # tools.system
    htop
    bottom
    # tools.network
    parsync
    # tools.cli
    ripgrep
    fd
    # tools.security
    osslsigncode
    # tools.archive
    internetarchive
  ];
in
{
  assertions = [
    {
      assertion = config.myConfig.apps.utilities.tools.system;
      message = "Tools system group must be enabled";
    }
    {
      assertion = config.myConfig.apps.utilities.tools.network;
      message = "Tools network group must be enabled";
    }
    {
      assertion = config.myConfig.apps.utilities.tools.cli;
      message = "Tools CLI group must be enabled";
    }
    {
      assertion = config.myConfig.apps.utilities.tools.security;
      message = "Tools security group must be enabled";
    }
    {
      assertion = config.myConfig.apps.utilities.tools.archive;
      message = "Tools archive group must be enabled";
    }
  ]
  ++ map (pkg: {
    assertion = lib.elem pkg config.environment.systemPackages;
    message = "Package missing: ${pkg.name}";
  }) requiredToolsPkgs;
}
