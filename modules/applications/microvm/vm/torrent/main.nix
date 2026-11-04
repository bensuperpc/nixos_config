{ pkgs, ipOf, ... }:
{
  microvm = {
    vcpu = 2;
    mem = 1536;
  };

  services.qbittorrent = {
    enable = true;
    webuiPort = 8080;
    torrentingPort = 6881;
    serverConfig = {
      LegalNotice.Accepted = true;
      BitTorrent.Session = {
        DefaultSavePath = "/var/lib/qBittorrent/qBittorrent/downloads";
        TempPathEnabled = true;
        TempPath = "/var/lib/qBittorrent/qBittorrent/incomplete";
      };
      Network.PortForwardingEnabled = false;
      Preferences.WebUI = {
        AlternativeUIEnabled = true;
        RootFolder = "${pkgs.vuetorrent}/share/vuetorrent";
        AuthSubnetWhitelistEnabled = true;
        AuthSubnetWhitelist = "${ipOf "edge"}/32";
        UseUPnP = false;
      };
    };
  };
}
