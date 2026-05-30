{ lib, ... }:

let
  # Nameservers with TLS SNI hostnames for DoT verification
  defaultNameservers = [
    "1.1.1.1#one.one.one.one"
    "1.0.0.1#one.one.one.one"
    "8.8.8.8#dns.google"
    "8.8.4.4#dns.google"
  ];
  fallbackNameservers = [
    "9.9.9.9#dns.quad9.net"
    "149.112.112.112#dns.quad9.net"
  ];
in
{
  # DNS over TLS via systemd-resolved
  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNSSEC = "allow-downgrade";
      DNSOverTLS = "allow-downgrade";
      Domains = [ "~." ];
      FallbackDNS = fallbackNameservers;
    };
  };

  networking = {
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      # Prevent DHCP from overriding the DoT-capable DNS servers configured in resolved.
      # Without this, the router's DNS (no DoT) takes over as the default route DNS.
      settings.connection = {
        "ipv4.ignore-auto-dns" = true;
        "ipv6.ignore-auto-dns" = true;
      };
    };
    nameservers = defaultNameservers;
  };
}
