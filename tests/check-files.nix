# tests/check-files.nix
{ config, pkgs, lib, vars, ... }:

let
  requiredFilePkgs = with pkgs; [
    # backup
    restic
    restic-browser
    # sync
    rclone
    syncthing
    localsend
    samba
    # tools
    recoll
    ranger
    # crypto
    veracrypt
  ];
in
{
  assertions =
    [
      {
        assertion = config.myConfig.apps.files.enableAll;
        message = "Files meta-module must be enabled";
      }
      {
        assertion = config.myConfig.apps.files.backup.core;
        message = "Files backup core group must be enabled";
      }
      {
        assertion = config.myConfig.apps.files.backup.profileManager;
        message = "Files backup profile manager group must be enabled";
      }
      {
        assertion = config.myConfig.apps.files.backup.gui;
        message = "Files backup GUI group must be enabled";
      }
      {
        assertion = config.myConfig.apps.files.sync.transfer;
        message = "Files sync transfer group must be enabled";
      }
      {
        assertion = config.myConfig.apps.files.sync.peerToPeer;
        message = "Files sync peer-to-peer group must be enabled";
      }
      {
        assertion = config.myConfig.apps.files.sync.networkShares;
        message = "Files sync network shares group must be enabled";
      }
      {
        assertion = config.myConfig.apps.files.sync.mobile;
        message = "Files sync mobile group must be enabled";
      }
      {
        assertion = config.myConfig.apps.files.tools.search;
        message = "Files tools search group must be enabled";
      }
      {
        assertion = config.myConfig.apps.files.tools.navigation;
        message = "Files tools navigation group must be enabled";
      }
      {
        assertion = config.myConfig.apps.files.tools.mobile;
        message = "Files tools mobile group must be enabled";
      }
      {
        assertion = config.myConfig.apps.files.crypto.veracrypt;
        message = "Files crypto VeraCrypt group must be enabled";
      }
      {
        assertion = config.services.syncthing.enable;
        message = "Syncthing service must be enabled";
      }
      {
        assertion = config.programs.localsend.openFirewall;
        message = "LocalSend firewall opening must be enabled";
      }
    ]
    ++ map (pkg: {
      assertion = lib.elem pkg config.environment.systemPackages;
      message = "Package missing: ${pkg.name}";
    }) requiredFilePkgs;
}
