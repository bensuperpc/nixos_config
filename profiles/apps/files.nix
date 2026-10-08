{ moduleHelpers, ... }:
{
  myConfig.apps.files = moduleHelpers.mkDefaults {
    backup = {
      core = true;
      profileManager = true;
      gui = true;
    };

    sync = {
      transfer = true;
      peerToPeer = true;
      networkShares = true;
      mobile = true;
    };

    crypto.enable = true;

    tools = {
      search = true;
      navigation = true;
    };
  };
}
