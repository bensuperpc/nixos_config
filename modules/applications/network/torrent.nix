{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.torrent;

  qbittorrentPackages = with pkgs; [
    qbittorrent
    qbittorrent-nox
  ];

  transmissionPackages = with pkgs; [
    transmission_4
    transmission_4-qt6
  ];

  helperPackages = with pkgs; [
    mkbrr
  ];

  enabledOptionalsPackages =
    lib.optionals cfg.qbittorrent qbittorrentPackages
    ++ lib.optionals cfg.transmission transmissionPackages
    ++ lib.optionals cfg.helpers helperPackages;

    anyEnabled = lib.any (x: x) [
      cfg.qbittorrent
      cfg.transmission
      cfg.helpers
    ];
in
{
  options.myConfig.apps.torrent = {
    qbittorrent = moduleHelpers.mkDisabledOption "Install qBittorrent client";
    transmission = moduleHelpers.mkDisabledOption "Install Transmission client";
    helpers = moduleHelpers.mkDisabledOption "Install torrent helper tools";
    openFirewall = moduleHelpers.mkDisabledOption "Open firewall for torrent clients";
  };

  config = lib.mkMerge [ 
    {
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
    })
    (lib.mkIf cfg.openFirewall {
      services.qbittorrent.openFirewall = lib.mkIf cfg.qbittorrent cfg.openFirewall;
      services.transmission.openFirewall = lib.mkIf cfg.transmission cfg.openFirewall;
    })
  ];
}
