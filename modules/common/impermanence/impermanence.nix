{
  config,
  lib,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.system.impermanence;

  persistDirectoriesDefault = [
    "/var/lib/nixos"
    "/var/lib/libvirt"
    "/var/lib/microvms"
    "/var/lib/bluetooth"
    "/var/lib/syncthing"
    "/var/lib/clamav"
    "/var/lib/NetworkManager"
    "/etc/NetworkManager/system-connections"
    # Docker/Podman
    "/var/lib/docker"
    "/var/lib/containers"
    "/var/lib/flatpak"
    "/var/lib/cups"
    "/var/lib/fail2ban"
    "/var/lib/fwupd"
    "/var/lib/AccountsService"
    "/var/lib/systemd/timers"
    "/var/lib/power-profiles-daemon"
    "/var/lib/boltd"
    "/var/lib/unbound"
    "/etc/secureboot"
    # Caddy
    "/var/lib/acme"
    "/var/lib/caddy"
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

    persistDirectories = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = persistDirectoriesDefault;
      description = "System directories bind-mounted from /persist.";
    };

    persistFiles = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = persistFilesDefault;
      description = "System files bind-mounted from /persist.";
    };

    rollback = {
      enable = moduleHelpers.mkEnabledOption "Wipe the root subvolume back to its blank snapshot on every boot";

      device = lib.mkOption {
        type = lib.types.str;
        default = "/dev/mapper/cryptroot";
        description = "Block device holding the btrfs filesystem (LUKS mapper name from lib/disko-presets.nix).";
      };

      rootSubvol = lib.mkOption {
        type = lib.types.str;
        default = "@root";
        description = "Name of the root subvolume that is recreated at each boot.";
      };

      blankSubvol = lib.mkOption {
        type = lib.types.str;
        default = "@root-blank";
        description = "Name of the read-only blank snapshot created by the disko postCreateHook.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.persistence."/persist" = {
      hideMounts = true;

      directories = cfg.persistDirectories;
      files = cfg.persistFiles;
    };

    fileSystems."/persist".neededForBoot = true;
    fileSystems."/var/log".neededForBoot = true;

    # Without this, sudo lectures after every boot.
    security.sudo.extraConfig = ''
      Defaults lecture = never
    '';

    # sops runs before the /persist bind mounts, so it must read the host key from /persist directly.
    sops.age.sshKeyPaths = lib.mkIf (lib.elem "/etc/ssh/ssh_host_ed25519_key" cfg.persistFiles) [
      "/persist/etc/ssh/ssh_host_ed25519_key"
    ];

    assertions = [
      {
        assertion = lib.elem "/var/lib/nixos" cfg.persistDirectories;
        message = "impermanence: /var/lib/nixos must be persisted.";
      }
      {
        # Losing it makes every secret undecryptable.
        assertion =
          !config.myConfig.system.secrets.enable || lib.elem "/etc/ssh/ssh_host_ed25519_key" cfg.persistFiles;
        message = "impermanence: /etc/ssh/ssh_host_ed25519_key must be persisted when sops secrets are enabled.";
      }
    ];
  };
}
