{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.myConfig.system.impermanence;
  inherit (cfg) rollback;
in
{
  config = lib.mkIf (cfg.enable && rollback.enable) {
    assertions = [
      {
        assertion = config.boot.initrd.systemd.enable;
        message = "myConfig.system.impermanence.rollback needs boot.initrd.systemd.enable = true.";
      }
    ];

    boot.initrd.systemd.services.rollback = {
      description = "Rollback the btrfs root subvolume to its blank snapshot";
      wantedBy = [ "initrd.target" ];
      after = [ "cryptsetup.target" ];
      before = [ "sysroot.mount" ];

      unitConfig.DefaultDependencies = "no";

      path = [
        pkgs.btrfs-progs
        pkgs.util-linux
        pkgs.coreutils
      ];

      serviceConfig = {
        Type = "oneshot";
        TimeoutStartSec = "45s";
      };

      script = ''
        set -euo pipefail

        DEVICE="${rollback.device}"
        ROOT="${rollback.rootSubvol}"
        BLANK="${rollback.blankSubvol}"

        MNT=$(mktemp -d)
        trap 'umount "$MNT" 2>/dev/null || true; rmdir "$MNT"' EXIT

        mount -t btrfs -o subvol=/ "$DEVICE" "$MNT"

        if ! btrfs subvolume show "$MNT/$BLANK" >/dev/null 2>&1; then
          echo "Missing blank subvolume, refusing rollback"
          exit 1
        fi

        if btrfs subvolume show "$MNT/$ROOT" >/dev/null 2>&1; then
          btrfs subvolume delete -R "$MNT/$ROOT"
        fi

        btrfs subvolume snapshot "$MNT/$BLANK" "$MNT/$ROOT"
      '';
    };
  };
}
