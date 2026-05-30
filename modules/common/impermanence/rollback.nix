{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.system.impermanence;
in
{
  config = lib.mkIf cfg.enable {
    programs.fuse.userAllowOther = true;

    fileSystems."/persist".neededForBoot = true;
    fileSystems."/var/log".neededForBoot = true;

    security.sudo.extraConfig = ''
      Defaults lecture = never
    '';

    boot.initrd.systemd.services.rollback = {
      wantedBy = [ "initrd.target" ];
      after = [ "dev-mapper-cryptroot.device" ];
      before = [ "sysroot.mount" ];

      unitConfig.DefaultDependencies = "no";

      serviceConfig = {
        Type = "oneshot";
        TimeoutStartSec = "30s";
      };

      script = ''
        set -euo pipefail

        DEVICE="${cfg.rollback.device}"
        ROOT="${cfg.rollback.rootSubvol}"
        BLANK="${cfg.rollback.blankSubvol}"

        MNT=$(mktemp -d)
        trap 'umount "$MNT" 2>/dev/null || true; rmdir "$MNT"' EXIT

        mount -t btrfs -o subvol=/ "$DEVICE" "$MNT"

        if ! btrfs subvolume show "$MNT/$BLANK" >/dev/null 2>&1; then
          echo "Missing blank subvolume, refusing rollback"
          exit 1
        fi

        if btrfs subvolume show "$MNT/$ROOT" >/dev/null 2>&1; then
          btrfs subvolume delete -R "$MNT/$ROOT" || true
        fi

        btrfs subvolume snapshot "$MNT/$BLANK" "$MNT/$ROOT"
      '';
    };
  };
}