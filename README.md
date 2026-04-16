# NixOS Configuration

Multi-host NixOS flake configuration for personal machines, family desktops and servers.

> **⚠️ Warning:** This repository is still under active development, expect changes and occasional breakage.

## Features

- Multi-host setup (personal, family, server)
- Role-based host composition (`minimal`, `server`, `desktop`, `workstation`, `family`)
- Platform / application module split for clear layering
- Dedicated policy profiles for system-wide defaults (kernel, storage)
- Profile-based capabilities (`appProfiles`, `platformProfiles`, `hwProfiles`, `policyProfiles`)
- Per-host user list (`users`) with per-user modules
- Validated host schema with early error reporting (`lib/host-schema.nix`)
- Clear variable inputs via `varsSystem`, `varsUsers`, `varsHost`
- Hardware drivers as composable profiles (Intel/AMD/Bluetooth/Wireless)
- Home Manager and Plasma Manager integration
- Colmena and deploy-rs for remote deployment (hosts with a known IP are auto-included)
- Docker-based helper commands via `Makefile`

![my desktop environment](assets/image.webp)

## Repository Layout

```bash
.
├── devshells           # Development shells
├── flake.lock          # Flake lock file
├── flake.nix           # Flake outputs and host wiring
├── lib
│   ├── host-schema.nix # Role defaults, host normalization and validation
│   ├── mksystem.nix    # Per-host NixOS configuration builder
│   └── options.nix     # Shared option helpers (mkEnabledOption, etc.)
├── Makefile
├── modules
│   ├── common      # Boot, network, audio, filesystem, SSH, …
│   ├── drivers     # GPU (Intel/AMD), Bluetooth, Wireless
│   ├── gui         # Display manager, KDE Plasma
│   └── applications # Layer 2 — User-facing software
│       ├── development  # IDEs, compilers, languages, tools
│       ├── multimedia   # Video, audio, image
│       ├── games        # Steam, emulators, Minecraft
│       ├── desktop      # Desktop integration, fonts, printing
│       ├── network      # Browsers, communication, torrent
│       ├── files        # Backup, sync, crypto
│       ├── utilities    # Misc tools, KVM, math, antivirus
│       ├── docker       # Docker and Compose services
│       └── custom       # Local custom packages
├── profiles            # Composable presets for platform, apps and policy
├── systems             # Per-host hardware configuration and variables
├── tests               # NixOS assertions (check-*.nix)
└── users               # Per-user system and Home Manager configuration
```

## Hosts

Defined in `systems/systems.nix`. Hosts without an IP are built but excluded from remote deployment targets.

| Host | Role | Status |
|---|---|---|
| `server-1-m710q` | workstation | active |
| `celestia` | family | WIP |
| `luna` | family | WIP |
| `rainbow-dash` | family | WIP |
| `fluttershy` | minimal | WIP |
| `pinkie-pie` | desktop | WIP |

## Prerequisites

- Linux machine with Nix installed
- Flakes enabled (`nix-command` + `flakes`)
- Optional for deployment:
  - `colmena`
  - `deploy-rs`
- Optional for Makefile workflow:
  - Docker

## Quick Start

### Validate the flake

```bash
nix flake show
nix flake check -L
```

### Build a host locally

```bash
nix build --extra-experimental-features "nix-command flakes" .#nixosConfigurations.server-1-m710q.config.system.build.toplevel
```

### Switch on a NixOS host

```bash
sudo nixos-rebuild switch --flake .#server-1-m710q
```

## Makefile Commands

General commands:

```bash
make update    # flake update
```

Host commands (for hosts listed in `SERVERS` inside `Makefile`):

```bash
make <host>.test   # dry-run build
make <host>.build  # build toplevel
make <host>.vm     # build VM
make <host>.push   # deploy with Colmena
```

Current `SERVERS` value in `Makefile`: `server-1-m710q fluttershy`.

> Note: `Makefile` host list and `systems/systems.nix` host list should be kept in sync.

## Deployment

Hosts with a defined `ip` field are automatically included in Colmena and deploy-rs outputs. WIP hosts simply omit the `ip` field.

### Colmena

```bash
colmena apply --on server-1-m710q --show-trace --verbose
```

## How Host Configuration Is Composed

`lib/mksystem.nix` builds each host from:

1. `systems/<host>/configuration.nix` (hardware + `system.stateVersion`)
2. All profiles resolved from role defaults + host `platformProfiles` + `appProfiles` + `hwProfiles` + `policyProfiles`
3. User modules from `users/<name>/system.nix` for each user in `users`
4. Core modules (`modules/common/`, `modules/drivers/`, `modules/gui/`) and application modules (`modules/applications/`)

Configuration inputs exposed to modules (`_module.args`):

- `varsSystem`: values from `systems/<host>/variables.nix`
- `varsUsers.<username>`: values from each `users/<name>/variables.nix`
- `varsHost`: host metadata (`name`, `role`, `users`, `deployUser`)

## Host Roles

Roles are defined in `lib/host-schema.nix` and provide default `platformProfiles`, `appProfiles`, `hwProfiles` and `policyProfiles`. Hosts can extend or override them.

| Role | Platform profiles | App profiles | Policy / extra profiles |
|---|---|---|---|
| `minimal` | `platform/base` | _(none)_ | _(none)_ |
| `server` | `platform/base`, `platform/no-gpu` | `apps/docker` | _(none)_ |
| `desktop` | `platform/base`, `platform/kde-plasma` | `apps/custom`, `apps/desktop-runtime`, `apps/desktop`, `apps/multimedia`, `apps/utilities`, `apps/office` | `policy/kernel-zen` |
| `workstation` | `platform/base`, `platform/kde-plasma` | `apps/custom`, `apps/desktop-runtime`, `apps/desktop`, `apps/development`, `apps/multimedia`, `apps/utilities`, `apps/office` | `policy/kernel-zen` |
| `family` | `platform/base`, `platform/kde-plasma` | `apps/desktop`, `apps/communication`, `apps/multimedia`, `apps/office`, `apps/files`, `apps/utilities` | `policy/kernel-zen` |

## Adding a New Host

1. Create four files under `systems/<host>/`:
   - `definition.nix` — role, profiles, IP, users (see example below)
   - `configuration.nix` — hardware + `system.stateVersion`
   - `hardware-configuration.nix` — generated by `nixos-generate-config`
   - `variables.nix` — host-specific variables (hostname, timezone, locale…)
2. Register the host in `systems/systems.nix`:

```nix
"my-host" = import ./my-host/definition.nix;
```

Example `definition.nix`:

```nix
{
  role = "desktop";           # minimal | server | desktop | workstation | family
  system = "x86_64-linux";
  # ip = "192.168.1.x";       # add when known — enables remote deployment

  users = [ "bensuperpc" ];
  # deployUser = "bensuperpc"; # optional — defaults to the first entry in users
                               # must be one of the users above

  appProfiles    = [ "apps/games" "apps/docker" ]; # optional extras on top of the role
  hwProfiles     = [ "platform/gpu-amd" "platform/wireless" ]; # hardware/driver profiles
  policyProfiles = [ "policy/kernel-zen" ]; # kernel and system-wide policies
}
```

`users` is required and must be a list (not `user` and not `userGroups`).

`hwProfiles` is for hardware/driver profiles (`platform/gpu-*`, `platform/bluetooth`, etc.).
`policyProfiles` is for system-wide policies (`policy/kernel-*`, etc.).

3. Optionally add it to `SERVERS` in `Makefile`.
4. Run:

```bash
make <host>.test
make <host>.push   # once ip is set
```

## Driver Profiles

Hardware drivers are activated via `hwProfiles`:

| Profile | Description |
|---|---|
| `platform/gpu-intel` | Intel GPU (VA-API, compute) |
| `platform/gpu-amd` | AMD GPU |
| `platform/bluetooth` | Bluetooth stack |
| `platform/wireless` | Wireless networking |
| `platform/no-gpu` | Headless / server (explicit no-GPU marker) |

## Policy Profiles

Policy profiles are activated via role defaults or `policyProfiles`:

| Profile | Description |
|---|---|
| `policy/kernel-latest` | Follow the latest kernel track |
| `policy/kernel-zen` | Prefer the Zen kernel for desktop-oriented hosts |
| `policy/kernel-latest-libre` | Follow the latest libre kernel track (no binary blobs) |
| `policy/kernel-latest-hardened` | Follow the latest hardened kernel track (security-focused) |

## Useful Resources

- [NixOS](https://nixos.org/)
- [NixOS Wiki](https://nixos.wiki/)
- [NixOS Search (Packages)](https://search.nixos.org/packages)
- [NixOS Search (Options)](https://search.nixos.org/options)
- [MyNixOS](https://mynixos.com/)
- [Best of Nix](https://github.com/best-of-lists/best-of)
- [Nix Gaming](https://github.com/fufexan/nix-gaming/)

# Other NixOS Configurations

- [CageKiosk](https://github.com/stefansebekow/CageKiosk)
- [Midna](https://git.midna.dev/mjm/nix-config)
- [Natto1784](https://github.com/natto1784/dotfiles)
- [Fufexan](https://github.com/fufexan/dotfiles)
- [Tejing1](https://github.com/tejing1/nixos-config)
- [Ryan4yin](https://github.com/ryan4yin/nix-config)
