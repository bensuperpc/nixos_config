{ pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:

{
  networking.hostName = vars.hostname;
  
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  services.timesyncd = {
    enable = true;
    servers = [ 
      "0.pool.ntp.org"
      "1.pool.ntp.org" 
      "2.pool.ntp.org"
      "3.pool.ntp.org"
    ];
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking = {
    networkmanager.enable = true;
    nameservers = [
    "1.1.1.1"
    "1.0.0.1"
    "8.8.8.8"
    "8.8.4.4"
    ];
    firewall = {
      enable = true;
      allowPing = true;
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;

  environment.systemPackages = with pkgs; [
    inetutils
    iproute2
    ethtool
    dig
  ];
}