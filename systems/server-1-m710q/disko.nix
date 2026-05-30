let
  btrfsOpts = [
    "compress=zstd:3"
    "noatime"
    "discard=async"
  ];
in
{
  disko.devices = {
    disk = {
      nvme0n1 = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-SAMSUNG_MZVLB256HAHQ-000H1_S425NA0K888091"; # /dev/nvme0n1
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              label = "boot";
              name = "ESP";
              size = "1024M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                ];
              };
            };
            luks = {
              size = "100%";
              label = "luks";
              content = {
                type = "luks";
                name = "cryptroot";
                extraOpenArgs = [
                  "--allow-discards"
                  "--perf-no_read_workqueue"
                  "--perf-no_write_workqueue"
                ];
                extraFormatArgs = [
                  "--pbkdf" "argon2id"
                  "--iter-time" "15000"
                  "--key-size" "512"
                ];
                settings = {
                  crypttabExtraOpts = [
                    "fido2-device=auto"
                    "tpm2-device=auto"
                    "token-timeout=40"];
                };
                content = {
                  type = "btrfs";
                  extraArgs = ["-L" "nixos" "-f"];
                  postCreateHook = ''
                    set -euo pipefail

                    MNTPOINT=$(mktemp -d)
                    mount /dev/mapper/cryptroot "$MNTPOINT" -o subvol=/

                    btrfs subvolume snapshot -r "$MNTPOINT/@root" "$MNTPOINT/@root-blank"

                    umount "$MNTPOINT"
                    rmdir "$MNTPOINT"
                  '';
                  subvolumes = {
                    "@root" = {
                      mountpoint = "/";
                      mountOptions = btrfsOpts;
                    };

                    "@home" = {
                      mountpoint = "/home";
                      mountOptions = btrfsOpts;
                    };

                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions = btrfsOpts;
                    };

                    "@persist" = {
                      mountpoint = "/persist";
                      mountOptions = btrfsOpts;
                    };

                    "@log" = {
                      mountpoint = "/var/log";
                      mountOptions = btrfsOpts;
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
