{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.files.sync;
  # Base packages that are always included.
  # Optional packages for each category.
  transferPackages = with pkgs; [
    rclone
    croc
  ];

  peerToPeerPackages = with pkgs; [
    syncthing
    syncthingtray
    localsend
  ];

  networkPackages = with pkgs; [
    filezilla
    samba
  ];

  mobilePackages = with pkgs; [
    adb-sync
  ];

  # Combine enabled optional packages based on configuration.
  enabledOptionalsPackages =
    lib.optionals cfg.transfer transferPackages
    ++ lib.optionals cfg.peerToPeer peerToPeerPackages
    ++ lib.optionals cfg.networkShares networkPackages
    ++ lib.optionals cfg.mobile mobilePackages;

  # If any optional category is enabled, we need to include the enabled packages and configure services.
  anyEnabled = lib.any (x: x) [
    cfg.transfer
    cfg.peerToPeer
    cfg.networkShares
    cfg.mobile
  ];
in
{
  options.myConfig.apps.files.sync = {
    transfer = moduleHelpers.mkDisabledOption "CLI transfer tools";
    peerToPeer = moduleHelpers.mkDisabledOption "P2P sync tools";
    networkShares = moduleHelpers.mkDisabledOption "network shares tools";
    mobile = moduleHelpers.mkDisabledOption "mobile sync tools";
  };

  config = lib.mkMerge [ 
    {
    }
    # Config that only applies if any optional category is enabled.
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;   
    })
    # Specific config configurations for individual options.
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