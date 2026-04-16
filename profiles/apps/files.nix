# profiles/files.nix — file management, backup, sync and crypto tools.
{ config, lib, pkgs, ... }:
{
  imports = [
    ../../tests/check-files.nix
  ];

  myConfig.apps.files.backup = {
    core = lib.mkDefault true;
    profileManager = lib.mkDefault true;
    gui = lib.mkDefault true;
  };

  myConfig.apps.files.sync = {
    transfer = lib.mkDefault true;
    peerToPeer = lib.mkDefault true;
    networkShares = lib.mkDefault true;
    mobile = lib.mkDefault true;
  };

  myConfig.apps.files.crypto = {
    veracrypt = lib.mkDefault true;
  };

  myConfig.apps.files.tools = {
    search = lib.mkDefault true;
    navigation = lib.mkDefault true;
  };
}
