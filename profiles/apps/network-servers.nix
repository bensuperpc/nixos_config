{ lib, ... }:
{
  myConfig.apps.network.servers = {
    core = lib.mkDefault true;
    reverseProxy = lib.mkDefault true;
  };
}
