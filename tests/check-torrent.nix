# tests/check-torrent.nix
{ config, pkgs, lib, vars, ... }:

let
  requiredPkgs = with pkgs; [
    # clients
    qbittorrent
    qbittorrent-nox
    transmission_4
    transmission_4-qt6
    # helpers
    mkbrr
  ];
in
{
  assertions =
    [
      {
        assertion = config.myConfig.apps.torrent.qbittorrent;
        message = "qBittorrent client must be enabled";
      }
      {
        assertion = config.myConfig.apps.torrent.transmission;
        message = "Transmission client must be enabled";
      }
      {
        assertion = config.myConfig.apps.torrent.helpers;
        message = "Torrent helper tools must be enabled";
      }
      {
        assertion = config.myConfig.apps.torrent.openFirewall;
        message = "Torrent firewall opening must be enabled";
      }
    ]
    ++ map (pkg: {
      assertion = lib.elem pkg config.environment.systemPackages;
      message = "Package missing: ${pkg.name}";
    }) requiredPkgs;
}
