{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.files.sync;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      transfer = {
        description = "CLI transfer tools";
        packages = with pkgs; [
          rclone
          croc
        ];
      };
      peerToPeer = {
        description = "P2P sync tools";
        packages = with pkgs; [
          syncthing
          syncthingtray
        ];
      };
      networkShares = {
        description = "network shares tools";
        packages = with pkgs; [
          filezilla
          samba
        ];
      };
      mobile = {
        description = "mobile sync tools";
        packages = with pkgs; [ better-adb-sync ];
      };
    };
  };
in
{
  options.myConfig.apps.files.sync = generated.options // {
    openFirewall = moduleHelpers.mkDisabledOption "Open the Syncthing (22000, 21027) and LocalSend (53317) ports in the firewall";
  };

  config = lib.mkMerge [
    generated.config
    (lib.mkIf cfg.peerToPeer {
      programs.localsend = {
        enable = true;
        inherit (cfg) openFirewall;
      };
    })
    (lib.mkIf (cfg.peerToPeer && cfg.openFirewall) {
      networking.firewall = {
        allowedTCPPorts = [ 22000 ];
        allowedUDPPorts = [
          22000
          21027
        ];
      };
    })
  ];
}
