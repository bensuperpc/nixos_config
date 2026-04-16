# tests/check-common.nix
{ config, pkgs, lib, ... }:

let
  requiredNetworkCliPkgs = with pkgs; [
    inetutils
    iproute2
    ethtool
    dig
  ];

  enableNetworkCliTooling = lib.attrByPath [ "myConfig" "apps" "network" "cli" "tooling" ] false config;
  # enableNetworkCliTooling = config.myConfig.apps.network.cli.tooling or false;
in
{
  assertions =
    [
      {
        assertion = config.boot.tmp.useZram;
        message = "Zram must be enabled";
      }
      # {
      #   assertion = config.boot.tmp.zramSettings."zram-size" == "ram * 0.5";
      #   message = "Zram size must be set to 50% of RAM";
      # }
      {
        assertion = config.zramSwap.enable;
        message = "Zram must be enabled";
      }
      {
        assertion = config.networking.networkmanager.enable;
        message = "NetworkManager must be enabled";
      }
      {
        assertion = config.networking.firewall.enable;
        message = "Firewall must be enabled";
      }
    ]
    ++ lib.optionals enableNetworkCliTooling (
      map (pkg: {
        assertion = lib.elem pkg config.environment.systemPackages;
        message = "Package missing: ${pkg.name}";
      }) requiredNetworkCliPkgs
    );
}