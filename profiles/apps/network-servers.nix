{ moduleHelpers, ... }:
{
  myConfig.apps.network.servers = moduleHelpers.mkDefaults {
    core = true;
    reverseProxy = true;
  };
}
