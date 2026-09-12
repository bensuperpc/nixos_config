# tests/check-common.nix
{
  config,
  pkgs,
  lib,
  ...
}:

let
  requiredNetworkCliPkgs = with pkgs; [
    inetutils
    iproute2
    ethtool
    dig
  ];

  enableNetworkCliTooling = lib.attrByPath [
    "myConfig"
    "apps"
    "network"
    "cli"
    "tooling"
  ] false config;
  # enableNetworkCliTooling = config.myConfig.apps.network.cli.tooling or false;

  # WSL guests hand networking, boot and swap management to the Windows host
  # (see modules/drivers/wsl.nix), so these invariants only apply to real installs.
  isWsl = config.myConfig.drivers.wsl.enable or false;
in
{
  assertions = [
    {
      assertion = config.boot.tmp.useZram;
      message = "Zram must be enabled";
    }
    {
      assertion = config.zramSwap.enable;
      message = "Zram must be enabled";
    }
  ]
  ++ lib.optionals (!isWsl) [
    {
      assertion = config.networking.networkmanager.enable;
      message = "NetworkManager must be enabled";
    }
    {
      assertion = config.networking.firewall.enable;
      message = "Firewall must be enabled";
    }
    {
      assertion = config.boot.loader.systemd-boot.enable;
      message = "Systemd-boot must be enabled";
    }
  ]
  ++ lib.optionals enableNetworkCliTooling (
    map (pkg: {
      assertion = lib.elem pkg config.environment.systemPackages;
      message = "Package missing: ${pkg.name}";
    }) requiredNetworkCliPkgs
  );
}
