{ pkgs, ... }:
{
  microvm = {
    vcpu = 2;
    mem = 1536;
  };

  networking.firewall = {
    allowedTCPPorts = [ 6881 ];
    allowedUDPPorts = [ 6881 ];
    extraInputRules = ''
      ip saddr 10.0.0.1 tcp dport { 8080 } accept
    '';
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
        AuthSubnetWhitelist = "10.0.0.1/32";
        UseUPnP = false;
      };
    };
  };
}
