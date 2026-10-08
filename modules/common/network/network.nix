{ config, varsHost, ... }:

let
  ntpServers = [
    "0.pool.ntp.org"
    "1.pool.ntp.org"
    "2.pool.ntp.org"
    "3.pool.ntp.org"
  ];
in
{
  services.timesyncd = {
    enable = true;
    servers = ntpServers;
  };

  myConfig.system.impermanence.persistDirectories = [
    "/var/lib/NetworkManager"
    "/etc/NetworkManager/system-connections"
  ];

  networking = {
    hostName = varsHost.name;
    networkmanager = {
      enable = true;
    };
    nftables.enable = true;
    firewall = {
      enable = true;
      allowPing = true;
    };
  };

  # Some programs need SUID wrappers
  programs.mtr.enable = true;

  assertions = [
    {
      assertion = config.networking.firewall.enable;
      message = "The firewall must stay enabled.";
    }
  ];
}
