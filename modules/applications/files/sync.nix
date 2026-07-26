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
          localsend
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
        packages = with pkgs; [ adb-sync ];
      };
    };
  };
in
{
  options.myConfig.apps.files.sync = generated.options;
  config = lib.mkMerge [
    generated.config
    (lib.mkIf cfg.peerToPeer {
      services.syncthing = {
        enable = true;
        # openDefaultPorts = true;
      };

      # Localsend firewall (correct nix style)
      programs.localsend = {
        openFirewall = true;
      };
    })
  ];
}
