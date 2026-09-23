{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.network.torrent;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      qbittorrent = {
        description = "Install qBittorrent client";
        packages = with pkgs; [
          qbittorrent
          qbittorrent-nox
        ];
      };
      transmission = {
        description = "Install Transmission client";
        packages = with pkgs; [
          transmission_4
          transmission_4-qt
        ];
      };
      helpers = {
        description = "Install torrent helper tools";
        packages = with pkgs; [ mkbrr ];
      };
    };
  };
in
{
  options.myConfig.apps.network.torrent = generated.options // {
    openFirewall = moduleHelpers.mkDisabledOption "Open the peer ports of the torrent clients in the firewall";

    ports = lib.mkOption {
      type = lib.types.listOf lib.types.port;
      default = [
        6881
        51413
      ];
      description = "Peer ports (TCP and UDP) opened by openFirewall. Must match the port set in each client (qBittorrent 6881, Transmission 51413 by default).";
    };
  };

  config = lib.mkMerge [
    generated.config
    (lib.mkIf cfg.openFirewall {
      networking.firewall = {
        allowedTCPPorts = cfg.ports;
        allowedUDPPorts = cfg.ports;
      };
    })
  ];
}
