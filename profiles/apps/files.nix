{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    #../../tests/check-files.nix
  ];

  myConfig.apps.files = {
    backup = {
      core = lib.mkDefault true;
      profileManager = lib.mkDefault true;
      gui = lib.mkDefault true;
    };

    sync = {
      transfer = lib.mkDefault true;
      peerToPeer = lib.mkDefault true;
      networkShares = lib.mkDefault true;
      mobile = lib.mkDefault true;
    };

    crypto = {
      veracrypt = lib.mkDefault true;
    };

    tools = {
      search = lib.mkDefault true;
      navigation = lib.mkDefault true;
    };
  };
}
