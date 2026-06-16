{ ... }:
{
  imports = [
    #../../tests/check-network-servers.nix
  ];

  myConfig.apps.network.servers.core = true;
  myConfig.apps.network.servers.reverseProxy = true;
}
