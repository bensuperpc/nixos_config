{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.network.cli;

  toolingPackages = with pkgs; [
    wireshark
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

  enabledOptionalsPackages = lib.optionals cfg.tooling toolingPackages;
in
{
  options.myConfig.apps.network.cli = {
    tooling = moduleHelpers.mkDisabledOption "Install networking and diagnostics tools";
  };

  config = lib.mkIf cfg.tooling {
    environment.systemPackages = enabledOptionalsPackages;
  };
}
