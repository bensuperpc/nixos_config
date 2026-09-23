{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.network.torrent;

  qbittorrentPackages = with pkgs; [
    qbittorrent
    qbittorrent-nox
  ];

  transmissionPackages = with pkgs; [
    transmission_4
    transmission_4-qt
  ];

  helperPackages = with pkgs; [
    mkbrr
  ];

  enabledOptionalsPackages =
    lib.optionals cfg.qbittorrent qbittorrentPackages
    ++ lib.optionals cfg.transmission transmissionPackages
    ++ lib.optionals cfg.helpers helperPackages;

  anyEnabled = cfg.qbittorrent || cfg.transmission || cfg.helpers;
in
{
  options.myConfig.apps.network.torrent = {
    qbittorrent = moduleHelpers.mkDisabledOption "Install qBittorrent client";
    transmission = moduleHelpers.mkDisabledOption "Install Transmission client";
    helpers = moduleHelpers.mkDisabledOption "Install torrent helper tools";
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
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
    })
    (lib.mkIf cfg.openFirewall {
      networking.firewall = {
        allowedTCPPorts = cfg.ports;
        allowedUDPPorts = cfg.ports;
      };
    })
  ];
}
