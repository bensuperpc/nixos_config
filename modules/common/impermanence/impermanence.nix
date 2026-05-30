{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.system.impermanence;

  persistDirectoriesDefault = [
    "/var/lib/nixos"
    "/var/lib/libvirt"
    "/var/lib/bluetooth"
    "/var/lib/syncthing"
    "/var/lib/clamav"
    "/var/lib/NetworkManager"
    "/etc/NetworkManager/system-connections"
    # Docker/Podman
    "/var/lib/docker"
    "/var/lib/containers"
  ];

  persistFilesDefault = [
    "/etc/machine-id"
    "/etc/adjtime"

    "/etc/ssh/ssh_host_ed25519_key"
    "/etc/ssh/ssh_host_ed25519_key.pub"
    "/etc/ssh/ssh_host_rsa_key"
    "/etc/ssh/ssh_host_rsa_key.pub"
  ];
in
{
  options.myConfig.system.impermanence = {
    enable = moduleHelpers.mkDisabledOption "opt-in persistence via /persist";

    rollback = {
      device = lib.mkOption {
        type = lib.types.str;
        default = "/dev/mapper/cryptroot";
      };

      rootSubvol = lib.mkOption {
        type = lib.types.str;
        default = "@root";
      };

      blankSubvol = lib.mkOption {
        type = lib.types.str;
        default = "@root-blank";
      };

      persistDirectories = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = persistDirectoriesDefault;
      };

      persistFiles = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = persistFilesDefault;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.persistence."/persist" = {
      hideMounts = true;

      directories = cfg.rollback.persistDirectories;
      files = cfg.rollback.persistFiles;
    };
  };
}