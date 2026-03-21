{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  cfg = config.myConfig.apps.networkingTools;

  basePackages = with pkgs; [ ];

  toolingPackages = with pkgs; [
    wireshark
    caddy
    nginx
    openvpn
    inetutils
    iproute2
    ethtool
    dig
    iperf3
    nmap
    traceroute
    mtr
  ];

  enabledOptionalsPackages =
    lib.optionals cfg.tooling toolingPackages;

  anyEnabled = lib.any (x: x) [
    cfg.tooling
  ];
in
{
  options.myConfig.apps.networkingTools = {
    tooling = moduleHelpers.mkEnabledOption "Install networking and diagnostics tools";
  };

  config = lib.mkMerge [
    {
      environment.systemPackages = basePackages;
    }

    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
    })
  ];
}
