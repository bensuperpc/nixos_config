{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.network.cli;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      tooling = {
        description = "Install networking and diagnostics tools";
        packages = with pkgs; [
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
      };
    };
  };
in
{
  options.myConfig.apps.network.cli = generated.options;
  config = generated.config;
}
