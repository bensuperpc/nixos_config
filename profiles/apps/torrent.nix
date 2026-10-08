{ moduleHelpers, ... }:
{
  myConfig.apps.network.torrent = moduleHelpers.mkDefaults {
    qbittorrent = true;
    transmission = true;
    helpers = true;
    openFirewall = true;
  };
}
