# AGENTS.md

Personal multi-host NixOS flake (flake-parts). Human docs (install, Secure Boot, TPM, sops enrollment, profile tables): [README.md](README.md). This file only lists what you need to work fast and safely.

## Map

| Path | Role |
| --- | --- |
| `flake.nix` / `flake-module.nix` | Inputs; outputs `nixosConfigurations`, `colmenaHive`, `devShells`, `checks` (see Commands), formatter `nixfmt-tree` |
| `systems/systems.nix` | Host registry (filters `enabled = false`, normalizes via `lib/host-schema.nix`) |
| `systems/<host>/` | `definition.nix` (role, profiles, ip, users, `ageRecipient`), `configuration.nix` (hw imports + `stateVersion` + host-only options), `hardware-configuration.nix`, `disko.nix`, `secrets.yaml` (sops, once enrolled) |
| `lib/mksystem.nix` | Builds one host: module list + `_module.args` |
| `lib/host-schema.nix`, `lib/role-presets.nix` | Validation (unknown keys throw), role → default profiles |
| `lib/module-helpers.nix` | `mkEnabledOption`, `mkDisabledOption`, `mkPackageGroupModule` |
| `lib/disko-presets.nix` | Shared GPT + ESP + LUKS + btrfs layout (`@root @home @home-snapshots @nix @persist @log`, `@root-blank` snapshot) |
| `profiles/{platform,apps,policy}/*.nix` | Thin presets that set `myConfig.*` options; referenced as `"platform/x"`, `"apps/x"`, `"policy/x"` |
| `modules/{common,drivers,gui,applications}` | Option definitions + implementations (all under `myConfig.*`) + the assertions guarding them |
| `users/<u>/{variables,system}.nix`, `users/<u>/home/`, `users/common/home/` | User account + Home Manager |
| `devshells/` | `nix develop .#<gcc\|qt6\|python313\|python2\|rust\|java>` (packages from `pkgsSets.stable-2605`), `.#raylib` (`pkgsSets.unstable`); `.#<esp32c5\|esp32c6\|esp32p4>` (ESP-IDF from the `nixpkgs-esp-dev` input, its own pinned nixpkgs) |
| `systems/<host>/secrets.yaml`, `.sops.yaml` | sops-nix (age), one encrypted file per host. The admin key lives in `~/.config/sops/age/keys.txt`, never in the repo |

`build/` (CMake output) is gitignored junk. `tests/{gcc,qt6,rust,java,python313,esp-idf}` are sample projects for the devshells, not Nix tests.

## How a host is composed

`definition.nix` → `host-schema` merges `role-presets[role]` + host `platformProfiles/appProfiles/policyProfiles` → `mksystem` imports each `profiles/<x>.nix`, `users/<u>/system.nix`, `modules/`, and `systems/<host>/configuration.nix` plus flake inputs (home-manager, impermanence, disko, sops, wsl, lanzaboote, microvm, nix-flatpak, nix-index-database).

Module args: `inputs`, `moduleHelpers` (specialArgs), `pkgsSets`, `varsHost` (`name role users deployUser ip port ageRecipient`), `varsUsers` (`variables.nix` of each of the host's users). Per-user modules also get `userVars`; Home Manager gets `inputs pkgsSets varsHost` (+ `userVars` for the user's HM modules).

`pkgs` = nixpkgs-unstable. `pkgsSets.<stable-2605|unstable>` for pinning individual packages.

Hosts: `server-1-m710q` (full, enrolled in sops), `rainbow-dash` and `fluttershy` (`bootstrap` until enrolled, target roles full/server in a comment), `discord-wsl` (wsl, no `ip` → not deployable), `celestia`/`luna`/`pinkie-pie` (`enabled = false`, no `configuration.nix` yet: enabling one requires creating it, `mksystem` throws otherwise). IPs live in each `definition.nix`. The three bare-metal hosts are still in preparation: do not deploy them. `fluttershy/disko.nix` holds a placeholder disk path to set before installing.

## Conventions

- Every option lives under `myConfig.<system|drivers|gui|boot|apps>.*`. Layout roughly mirrors the path (`modules/applications/network/browser.nix` → `myConfig.apps.network.browser.*`), but not always (`network/web-servers.nix` → `apps.network.servers`): grep the `options.myConfig` line.
- Package-only modules use `moduleHelpers.mkPackageGroupModule` (see `modules/applications/ai/ai.nix` as the smallest example): each group = one boolean option, packages go to `environment.systemPackages`. `enabledByDefault = true` for on-by-default, otherwise `false`. Wire it with `options.myConfig.apps.<x> = generated.options; inherit (generated) config;`.
- Profiles only set options. Use `lib.mkDefault` for app toggles so a host can override them in `configuration.nix`; `mkForce` only for hard platform constraints (see `drivers/wsl.nix`, `secureboot.nix`).
- Invariants are `assertions` in the module that owns the feature, checked on the final config (e.g. `services.openssh.*` in `services/ssh.nix`, firewall in `network/network.nix`, bootloader in `boot.nix`, impermanence prerequisites, sops enrollment in `nixos/secrets.nix`). Only assert real invariants (security, bootability, data safety, platform constraints like `platform/no-gui`), never "the profile set X to true".
- Hardware/profile split: hardware and disk details in `systems/<host>/`, capabilities in profiles, never hardcode host names in `modules/` (use `varsHost`).
- Nix style: `nixfmt` (via `nix fmt`), statix-clean, deadnix-clean (unused args → use `_`/`...`). Comments in English, short, explain *why*.
- Commits: `Update DD-MM-YYYY` style on branch `dev`, `main` is the PR base.

## Recipes

**New app module**: create `modules/applications/<cat>/<name>.nix` (options + `mkPackageGroupModule`), add to that dir's `default.nix`, enable it from a `profiles/apps/*.nix`, and add the profile to a role in `lib/role-presets.nix` or a host's `appProfiles`.

**New local package**: add `modules/applications/custom/packages/<name>.nix` and register it in `modules/applications/custom/packages/default.nix`: it is then built by `nix flake check`. To install it, add an option for it in `modules/applications/custom/default.nix` (and enable it in `profiles/apps/custom.nix` if wanted).

**New profile**: add `profiles/<platform|apps|policy>/<name>.nix`, reference it as `"<kind>/<name>"` in `definition.nix` or `role-presets.nix`. A missing file makes `mksystem` throw.

**New host**: copy an existing `systems/<host>/`, edit `definition.nix`/`disko.nix`/hardware config, register in `systems/systems.nix` (the Makefile reads hosts from the flake). Use `role = "bootstrap"` without `ageRecipient` until sops enrollment (README): any other role (except `wsl`) requires `ageRecipient` and fails evaluation otherwise. Keep the target role in a comment.

**Stateful path on impermanence hosts** (`platform/impermanence`: root is wiped each boot): add the dir/file to `persistDirectories`/`persistFiles` in `modules/common/impermanence/impermanence.nix`, or it will be lost on reboot. `/var/lib/private` (DynamicUser state) is deliberately not persisted: it needs mode `0700`.

**Secrets**: sops-nix with age keys in `.sops.yaml` (admin + `server_1_m710q`; other hosts are not recipients yet, enroll them per the README). One file per host, `systems/<host>/secrets.yaml` (= `sops.defaultSopsFile`, no shared file: a secret needed on several hosts is copied into each file), readable by the admin key and that host only; it holds `bensuperpc/password` and any host secret (e.g. the MicroVM example). `myConfig.system.secrets.enable` defaults to `varsHost.ageRecipient != null`; assertions require the file to exist and be encrypted for that key, and any role other than `bootstrap`/`wsl` to have an `ageRecipient`; `checks.sops-<host>` fails if a declared `sops.secrets` key is missing from the file. `bootstrap` hosts get the temporary `initialPassword`. Commands (edit/set/unset/updatekeys): README "Managing secrets". Never print, decrypt into the repo, or commit plaintext secrets; adding a recipient means `sops updatekeys` on the host file.

## Commands

```bash
nix fmt                                   # format (nixfmt-tree)
nix flake check -L                        # = CI: nixfmt, statix, deadnix, eval-<host> (every host fully
                                          # instantiated, all assertions), colmena-parity, sops-<host> (every declared
                                          # secret exists in the host file, no decryption), local packages built
nix eval --json .#nixosConfigurations --apply builtins.attrNames   # list active hosts
nix eval --raw .#nixosConfigurations.<host>.config.system.build.toplevel.drvPath   # evaluate one host
make <host>.test|build|vm|sbom            # inside a nixos/nix Docker container (repo mounted at /etc/nixos)
make <host>.push | <host>.boot            # colmena apply / apply boot --reboot (host-side colmena, buildOnTarget = true)
```

CI (`.github/workflows/ci.yml`, on `main`, `dev` and PRs): gitleaks, then `nix flake check -L`.

## Gotchas

- **Flakes only see git-tracked files**: `git add` new files before `nix build/eval`, or they are ignored / "path does not exist".
- Never use a `path:` flake reference: it copies untracked and gitignored files into the world-readable store (and into the system closure through `inputs.self`).
- `nix flake check` on `nixosConfigurations` alone only forces `toplevel.type`: the `eval-<host>` checks are what catch errors inside derivations.
- Colmena evaluates nodes through `eval-config.nix`, not `lib.nixosSystem`: `flake-module.nix` adds the missing bits (`nixosSystemParity`) and `checks.colmena-parity` fails on any drift.
- The ESP-IDF package reads `tools.json` from its source at evaluation time (IFD): `nix flake check` (and CI) fetch ESP-IDF with all its submodules to evaluate the `esp32*` devShells. Do not make `nixpkgs-esp-dev` follow our nixpkgs: its tools need `python310`.
- `colmenaHive` shows as an "unknown flake output" warning: harmless.
- Hosts keep no clone of the repo: `programs.nh.flake` (and the `nr*` aliases) point to `github:bensuperpc/nixos_config`, so a host rebuilds only pushed commits; deployments normally come from the admin machine (Colmena, `allowLocalDeployment = true` for `colmena apply-local` from a manual checkout).
- Users are immutable (`users.mutableUsers = false`): passwords only come from sops or the bootstrap `initialPassword`.
- Do not change `system.stateVersion` (`26.05`) in existing hosts.
- **Intentional, do not "fix"**: root has no password / is not declared, and `bensuperpc` has `NOPASSWD: ALL` sudo (`users/bensuperpc/system.nix`). Colmena needs non-interactive escalation. SSH: key-only, `PermitRootLogin = "no"`, fail2ban, port from `varsHost.port` (`modules/common/services/ssh.nix`).
- `platform/no-gui` asserts no desktop/browser/chat/office; `platform/wsl` disables sshd, firmware and (by default) sops; `drivers/wsl.nix` force-disables firewall, nftables, NetworkManager, resolved, timesyncd and systemd-boot.
- Secure Boot is disabled on every host: `platform/secureboot` is kept but not usable yet on impermanence hosts (`pkiBundle` defaults to `/etc/secureboot`, which is persisted, but sbctl ≥ 0.15 writes its keys to `/var/lib/sbctl`, which is not). Without it, TPM2 auto-unlock must use a PIN (README).
- The initrd has no emergency shell (`boot.initrd.systemd.emergencyAccess` left at `false`): recover through older systemd-boot generations or install media.
- `myConfig.boot.kernel` (enum: latest, zen, hardened, libre, lts) feeds `boot.kernelPackages` with `mkOverride 50`; change it through `policy/kernel-*` profiles (role default `kernel-latest` uses `mkDefault`).
- `modules/applications/custom/` holds local packages (`packages/*.nix`) and an overlay (raylib 6.0), each behind an option.
