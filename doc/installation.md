# Installation

To install on a new machine, you need a live USB with the NixOS installer, the example below uses the `server-1-m710q` target, but you can copy `server-1-m710q` and update ip, name, the `definition.nix` and `disko.nix` files for a new host, then add it to `systems/systems.nix`.

A host is enrolled in sops-nix **before** it is installed: its SSH host key is generated from the live USB (below), so the system is installed once, directly with its real role.

After booting the live USB, list the disks to identify the target device:

```bash
ls -l /dev/disk/by-id/
```

Generate the hardware configuration file for the target machine and remove `fileSystems`, `boot.initrd.luks.devices` and `swapDevices`, all are handled by `disko.nix`:

```bash
sudo nixos-generate-config --show-hardware-config > ./systems/server-1-m710q/hardware-configuration.nix
```

Flakes only see files tracked by git: `git add` every new or regenerated file under `systems/<host>/` before running `disko` or `nixos-install`.

Update the `device` field in `systems/server-1-m710q/disko.nix` to match the target disk (e.g. `/dev/disk/by-id/nvme-SAMSUNG_MZVLB256HAHQ-000H1_S425NA0K888091` or `/dev/nvme0n1`), then run the following command from the repository root (**this will format the entire target disk**) and enter the LUKS passphrase when prompted (`--inputs-from .` runs the disko revision locked in `flake.lock`, the same as the module).

```bash
sudo nix run --extra-experimental-features "nix-command flakes" --inputs-from . disko -- --mode destroy,format,mount ./systems/server-1-m710q/disko.nix
```

## Enroll the host in sops-nix

Generate the SSH host key of the new system, sops-nix decrypts the host secrets with it (`/mnt/persist/etc/ssh` with `platform/impermanence`, `/mnt/etc/ssh` without):

```bash
sudo mkdir -p /mnt/persist/etc/ssh
sudo ssh-keygen -t ed25519 -N "" -f /mnt/persist/etc/ssh/ssh_host_ed25519_key
```

**1. Get the age recipient of the host**, on the target (live USB):

```bash
nix shell --extra-experimental-features "nix-command flakes" nixpkgs#ssh-to-age -c ssh-to-age -i /mnt/persist/etc/ssh/ssh_host_ed25519_key.pub
# age1...
```

The next steps run on the admin PC, from the repository root:

```bash
nix shell nixpkgs#sops nixpkgs#ssh-to-age nixpkgs#mkpasswd nixpkgs#jq
export SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt
HOST=server-1-m710q
IP=192.168.1.26
```

**2. Already installed host only** (e.g. rotating its key): read the recipient over the network instead, after checking that both fingerprints match:

```bash
ssh-keygen -lf /etc/ssh/ssh_host_ed25519_key.pub          # on the target
ssh-keyscan -t ed25519 $IP 2>/dev/null | ssh-keygen -lf -  # on the PC
ssh-keyscan -t ed25519 $IP 2>/dev/null | ssh-to-age
```

**3. Add it to `.sops.yaml`**: a new anchor under `keys` and a rule for the host file (if the host is already listed from a previous install, **replace** its old key):

```yaml
keys:
  - &admin_bensuperpc age1...
  - &server_1_m710q age1...   # <- output of step 1

creation_rules:
  - path_regex: systems/server-1-m710q/secrets\.yaml$
    key_groups:
      - age:
          - *admin_bensuperpc
          - *server_1_m710q
```

**4. Create or re-encrypt the host secrets file** `systems/$HOST/secrets.yaml`, each host has its own
file, readable by the admin key and that host only:

```bash
# New file: `sops edit` creates it encrypted for the rule of step 3 (write any placeholder key,
# e.g. `bensuperpc: {}`, save and quit), then set the password hash
sops edit systems/$HOST/secrets.yaml
mkpasswd -m yescrypt | jq -R . | sops set --value-stdin systems/$HOST/secrets.yaml '["bensuperpc"]["password"]'

# Existing file (reinstall, host key change): re-encrypt it for the new recipient instead
sops updatekeys -y systems/$HOST/secrets.yaml
```

Check that the new recipient is listed, and that the admin key still decrypts:

```bash
grep 'recipient:' systems/$HOST/secrets.yaml
sops decrypt systems/$HOST/secrets.yaml > /dev/null && echo OK
```

**5. Declare the recipient in `systems/<host>/definition.nix`** (`ageRecipient = "age1...";`, the output of step 1)
and set `enabled = true`

**Reinstalling an enrolled host** formats its disk, hence a new host key: generate it the same way,
then redo steps 1 and 3 with it (replace the old key in `.sops.yaml` and `ageRecipient`, `sops updatekeys`).

## Managing secrets

Secrets live in `systems/<host>/secrets.yaml` (one file per host, no shared file: a secret needed on
several hosts is copied into each file). Run these from the repository root on the admin PC:

```bash
nix --extra-experimental-features "nix-command flakes" shell nixpkgs#sops nixpkgs#jq nixpkgs#mkpasswd
export SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt
File=systems/server-1-m710q/secrets.yaml
```

| Task | Command |
| --- | --- |
| Edit the whole file (opens `$EDITOR`, re-encrypts on save) | `sops edit $File` |
| Add or change a value (from stdin, not visible in `ps`) | `printf '%s' 'the value' \| jq -R . \| sops set --value-stdin $File '["api"]["token"]'` |
| Change the `bensuperpc` password | `mkpasswd -m yescrypt \| jq -R . \| sops set --value-stdin $File '["bensuperpc"]["password"]'` |
| Remove a value (or a whole branch: `'["api"]'`) | `sops unset $File '["api"]["token"]'` |
| Read one value | `sops decrypt --extract '["api"]["token"]' $File` |
| List the keys without values | `sops decrypt $File \| grep -v '^ '` or read the plaintext key names in `$File` |
| After editing `.sops.yaml` recipients (key added, removed or replaced) | `sops updatekeys -y $File` |

`sops set --value-stdin` expects a JSON value, hence `jq -R .` to turn a raw line into a JSON string.

A new secret must also be declared in Nix, in the module that uses it, then referenced by path:

```nix
sops.secrets."api/token" = { };                        # key ["api"]["token"] of the host file
# ... = config.sops.secrets."api/token".path;         # /run/secrets/api/token at runtime
```

`nix flake check` builds a `sops-<host>` check that fails if a declared secret is missing from the host
file (no decryption involved). Removing a value from the file therefore also means removing its
`sops.secrets` declaration.

**Rotating the admin key**: generate a new key, put its public key in place of `&admin_bensuperpc` in
`.sops.yaml`, then:

```bash
for File in systems/*/secrets.yaml; do
  SOPS_AGE_KEY_FILE=/path/to/old/keys.txt sops updatekeys -y $File   # new recipients, same data key
  sops rotate -i $File                                              # new data key, with the new key
done
```

`updatekeys` alone keeps the data key, which the old key can still unwrap. If the old key leaked, also
change the secret values: it decrypts them in every past revision of the file.

## Install the system

```bash
sudo nixos-install --flake .#server-1-m710q --root /mnt --no-root-passwd --show-trace
```

Then reboot into the installed system, the next sections run on it.

## Secure Boot (Lanzaboote)

Skip this section if this host won't use `platform/secureboot`, go straight to [Enroll TPM2 for LUKS auto-unlock](#enroll-tpm2-for-luks-auto-unlock) below.

**Do this before enrolling TPM2**

`platform/secureboot` swaps `systemd-boot` for [Lanzaboote](https://github.com/nix-community/lanzaboote), which signs the boot stub and kernel so the firmware can verify them.

The keys are enrolled in the firmware last, once everything on the ESP is signed:

1. Still on `systemd-boot`, create the keys with `sbctl` (already installed by default, see [modules/common/boot.nix](../modules/common/boot.nix)). With impermanence, `/var/lib/sbctl` must be the bind mount from `/persist` (it is on every host, with or without the profile): keys created outside of it are lost at the next reboot.

```bash
findmnt /var/lib/sbctl   # impermanence only: must list a mount
sudo sbctl create-keys
```

2. Add `"platform/secureboot"` to the host's `profiles` in `systems/<host>/definition.nix`.
3. Rebuild and switch, this is the step that signs the Lanzaboote stub and kernels with the keys of step 1, then check the result (the kernel images under `/boot/EFI/nixos/` are expected to stay unsigned):

```bash
sudo nixos-rebuild switch --flake .#<host>
sudo sbctl verify
```

4. Reboot into the firmware setup and put Secure Boot into **Setup Mode** (clear/reset the platform key).
5. Boot the system and enroll the keys:

```bash
sudo sbctl enroll-keys --microsoft
```

6. Reboot (enable Secure Boot enforcement in the firmware if it did not do it itself), then verify:

```bash
sbctl status
bootctl status
```

`myConfig.system.secureboot.pkiBundle` must match the path `sbctl` wrote the keys to (`/var/lib/sbctl`, the default, unless `sbctl` is configured otherwise).

## Enroll TPM2 for LUKS auto-unlock

### Without Secure Boot

```bash
sudo systemd-cryptenroll /dev/disk/by-partlabel/luks --tpm2-device=auto --tpm2-with-pin=yes
```

Dropping `--tpm2-with-pin=yes` unlocks without a PIN: only do it on machines where physical theft is not part of the threat model.

### With Secure Boot

```bash
sudo systemd-cryptenroll /dev/disk/by-partlabel/luks --tpm2-device=auto --tpm2-pcrs=0+1+2+7
```

PCR 0, 1 and 2 measure the firmware code, its settings and the option ROMs, PCR 7 the Secure Boot state. After a firmware update (`fwupdmgr` included), a BIOS setting change or a Secure Boot change (re-running `sbctl enroll-keys`, toggling it in firmware), auto-unlock stops working: the boot falls back to the LUKS passphrase prompt (a headless host waits there) until you wipe and re-enroll:

```bash
sudo systemd-cryptenroll /dev/disk/by-partlabel/luks --wipe-slot=tpm2
sudo systemd-cryptenroll /dev/disk/by-partlabel/luks --tpm2-device=auto --tpm2-pcrs=0+1+2+7
```

## Extra

I recommend to do a backup of the LUKS header: 

```bash
sudo cryptsetup luksHeaderBackup /dev/disk/by-partlabel/luks --header-backup-file luks-header-server-1-m710q.img
```

You can now reboot.

To restore the header from backup **if needed**:

```bash
sudo cryptsetup luksHeaderRestore /dev/disk/by-partlabel/luks --header-backup-file luks-header-server-1-m710q.img
```
