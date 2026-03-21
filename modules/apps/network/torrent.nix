{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  cfg = config.myConfig.apps.torrent;

  basePackages = with pkgs; [
  ];

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
    qbittorrent = moduleHelpers.mkEnabledOption "Install qBittorrent client";
    transmission = moduleHelpers.mkEnabledOption "Install Transmission client";
    helpers = moduleHelpers.mkEnabledOption "Install torrent helper tools";
    openFirewall = moduleHelpers.mkEnabledOption "Open firewall for torrent clients";
  };

  config = lib.mkMerge [ 
    {
      environment.systemPackages = basePackages;
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
