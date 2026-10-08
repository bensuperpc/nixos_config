{
  config,
  lib,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.system.impermanence;

  persistDirectoriesBase = [
    "/var/lib/nixos"
    "/var/lib/systemd/timers"
    "/var/lib/systemd/pstore"
    "/var/lib/lastlog"
    "/var/lib/logrotate"
  ]
  ++ lib.optional config.systemd.coredump.enable "/var/lib/systemd/coredump"
  ++ lib.optional config.services.upower.enable "/var/lib/upower"
  ++ lib.optional config.services.accounts-daemon.enable "/var/lib/AccountsService"
  ++ lib.optional config.services.hardware.bolt.enable "/var/lib/boltd"
  ++ lib.optional (config.security.acme.certs != { }) "/var/lib/acme";

  persistFilesBase = [
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
      type = lib.types.listOf (lib.types.either lib.types.str lib.types.attrs);
      default = [ ];
      description = "System directories bind-mounted from /persist (path, or impermanence attribute set to set the owner). Each module adds its own.";
    };

    persistFiles = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
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

  config = lib.mkMerge [
    {
      myConfig.system.impermanence = {
        persistDirectories = persistDirectoriesBase;
        persistFiles = persistFilesBase;
      };
    }
    (lib.mkIf cfg.enable {
      environment.persistence."/persist" = {
        hideMounts = true;

        directories = cfg.persistDirectories;
        files = cfg.persistFiles;
      };

      fileSystems."/persist".neededForBoot = true;
      fileSystems."/var/log".neededForBoot = true;

      # logrotate replaces its state file on every run, which a single bind-mounted file does not survive.
      services.logrotate.extraArgs = [
        "--state"
        "/var/lib/logrotate/logrotate.status"
      ];

      security.sudo.extraConfig = ''
        Defaults lecture = never
      '';

      # sops runs before the /persist bind mounts, so it must read the host key from /persist directly.
      sops.age.sshKeyPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];

      assertions = [
        {
          assertion = lib.elem "/var/lib/nixos" cfg.persistDirectories;
          message = "impermanence: /var/lib/nixos must be persisted.";
        }
        {
          assertion = lib.elem "/etc/ssh/ssh_host_ed25519_key" cfg.persistFiles;
          message = "impermanence: /etc/ssh/ssh_host_ed25519_key must be persisted, sops decrypts with it.";
        }
      ];
    })
  ];
}
