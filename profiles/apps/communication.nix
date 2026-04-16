# profiles/communication.nix — browsers, messaging, voice and torrenting.
{ config, lib, pkgs, ... }:
{
  imports = [
    ../../tests/check-browser.nix
    ../../tests/check-torrent.nix
  ];

  myConfig.apps.browser = {
    core = true;
    extra = true;
  };

  myConfig.apps.communication = {
    chat = true;
    voice = true;
    mail = true;
    terminal = true;
  };

  myConfig.apps.torrent = {
    qbittorrent = true;
    transmission = true;
    helpers = true;
    openFirewall = true;
  };
}
