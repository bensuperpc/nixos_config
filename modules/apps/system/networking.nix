{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  ntpServers = [
    "0.pool.ntp.org"
    "1.pool.ntp.org"
    "2.pool.ntp.org"
    "3.pool.ntp.org"
  ];

  defaultNameservers = [
    "1.1.1.1"
    "1.0.0.1"
    "8.8.8.8"
    "8.8.4.4"
  ];
in
{
  networking.hostName = vars.system.hostname;
  networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  services.timesyncd = {
    enable = true;
    servers = ntpServers;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking = {
    networkmanager.enable = true;
    nftables.enable = true;
    nameservers = defaultNameservers;
    firewall = {
      enable = true;
      allowPing = true;
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;

  environment.systemPackages = with pkgs; [
  ];
}
