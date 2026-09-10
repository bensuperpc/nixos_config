{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    #../../tests/check-torrent.nix
  ];

  myConfig.apps.network.torrent = {
    qbittorrent = lib.mkDefault true;
    transmission = lib.mkDefault true;
    helpers = lib.mkDefault true;
    openFirewall = lib.mkDefault true;
  };
}
