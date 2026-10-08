{
  config,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.network.cli;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      enable = {
        description = "Install networking and diagnostics tools";
        packages = with pkgs; [
          wireshark
          openvpn
          inetutils
          ethtool
          dig
          iperf3
          nmap
          traceroute
        ];
      };
    };
  };
in
{
  options.myConfig.apps.network.cli = generated.options;
  inherit (generated) config;
}
