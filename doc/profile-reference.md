# Profile Reference

## Driver & Platform Profiles

Hardware drivers and platform flags are activated via `profiles`:

| Profile                      | NixOS option set                                                          | Description                                                                           |
| ---------------------------- | ------------------------------------------------------------------------- | ------------------------------------------------------------------------------------- |
| `platform/gpu-intel-old`     | `myConfig.drivers.gpu.intel = { enable = true; generation = "old"; }`     | Intel iGPU (Haswell and older)                                                        |
| `platform/gpu-intel-skylake` | `myConfig.drivers.gpu.intel = { enable = true; generation = "skylake"; }` | Intel iGPU (Broadwell to Comet Lake)                                                  |
| `platform/gpu-intel-xe`      | `myConfig.drivers.gpu.intel = { enable = true; generation = "xe"; }`      | Intel GPU (Xe / Arc, Alder Lake and newer)                                            |
| `platform/gpu-software`      | `myConfig.drivers.gpu.software.enable = true`                             | Software GPU driver stack, no hardware GPU (e.g. virtual machines)                    |
| `platform/cpu-intel`         | `myConfig.drivers.cpu.intel.enable = true`                                | Intel CPU (KVM)                                                                       |
| `platform/cpu-amd`           | `myConfig.drivers.cpu.amd.enable = true`                                  | AMD CPU (KVM)                                                                         |
| `platform/gpu-amd`           | `myConfig.drivers.gpu.amd.enable = true`                                  | AMD GPU (GCN and RDNA)                                                                |
| `platform/bluetooth`         | `myConfig.drivers.bluetooth.enable = true`                                | Bluetooth stack                                                                       |
| `platform/tpm`               | `myConfig.system.tpm.enable = true`                                       | TPM 2.0 support and systemd-cryptenroll integration                                   |
| `platform/secureboot`        | `myConfig.system.secureboot.enable = true`                                | Secure Boot via Lanzaboote; replaces `systemd-boot`                                   |
| `platform/no-gui`            | fonts off + assertions                                                    | Headless: asserts no desktop/display manager and no GUI apps (browsers, chat, office) |
| `platform/impermanence`      | `myConfig.system.impermanence.enable = true`                              | `/persist` bind mounts and root rollback to `@root-blank` at each boot                |
| `platform/snapper`           | `myConfig.system.snapper.enable = true`                                   | Snapper btrfs snapshots                                                               |

> `myConfig.drivers.gpu.intel.{enable,generation}` and `myConfig.drivers.gpu.amd.enable` can be set directly in `systems/<host>/configuration.nix` without a profile.

## GUI Profiles

Desktop environment is activated via `profiles`:

| Profile               | `myConfig.gui.desktop` value | Description                                                                                                                 |
| --------------------- | ---------------------------- | --------------------------------------------------------------------------------------------------------------------------- |
| `platform/kde-plasma` | `"plasma"`                   | KDE Plasma 6: sets `myConfig.gui.desktop = "plasma"` and `myConfig.gui.plasma.{integration,utilities,multimedia,education}` |
| `platform/lxqt`       | `"lxqt"`                     | LXQt (SDDM + Xorg): sets `myConfig.gui.desktop = "lxqt"`                                                                    |

> `myConfig.gui.desktop` can also be set directly in `systems/<host>/configuration.nix` without a profile.
> `myConfig.gui.plasma.games` and `myConfig.gui.plasma.development` are enabled by `apps/games` and `apps/dev-all`.

## Policy Profiles

Policy profiles are activated via role defaults or `profiles`:

| Profile                | `myConfig.system.kernel` value | Description                                                                                                       |
| ---------------------- | ------------------------------ | ----------------------------------------------------------------------------------------------------------------- |
| `policy/kernel-latest` | `"latest"`                     | Latest upstream kernel (role default, set with `mkDefault`: any other `policy/kernel-*` profile on the host wins) |
| `policy/kernel-zen`    | `"zen"`                        | Zen kernel: desktop/gaming optimised                                                                              |
| `policy/kernel-lts`    | `"lts"`                        | Default NixOS LTS kernel (`linuxPackages`)                                                                        |

> `myConfig.system.kernel` can also be set directly in `systems/<host>/configuration.nix` without a profile.

## App Profiles

Activated via role defaults or `profiles`. Every toggle is set with `lib.mkDefault`, so a host can
turn a single group off in its `configuration.nix`.

| Profile                | Options set                                                                      | Description                                                                                                                                                                           |
| ---------------------- | -------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `apps/ai`              | `myConfig.apps.ai.enable`                                                        | AI tools                                                                                                                                                                              |
| `apps/browser`         | `myConfig.apps.network.browser.{core,privacy,extra,cli}`                         | Firefox and Chromium, Tor Browser and LibreWolf, extra and CLI browsers                                                                                                               |
| `apps/communication`   | `myConfig.apps.network.communication.*`                                          | Chat, voice, mail and terminal clients                                                                                                                                                |
| `apps/desktop`         | `myConfig.system.power.management`, `myConfig.apps.utilities.hardware`           | Power profiles daemon, hardware info tools (GUI + CLI)                                                                                                                                |
| `apps/desktop-runtime` | `myConfig.apps.network.cli.enable`, `myConfig.apps.desktop.terminal.enable`      | Network CLI tools and extra GPU-accelerated terminals                                                                                                                                 |
| `apps/dev-all`         | `myConfig.apps.development.*`, `myConfig.gui.plasma.development`                 | Full development stack: GCC base tools, Qt Creator, Python, Rust, Go, IDEs, databases… (Clang, WebAssembly, embedded compilers, Protocol Buffers and libraries live in the devshells) |
| `apps/dev-base`        | `myConfig.apps.development.dev.base`                                             | Base development tools only                                                                                                                                                           |
| `apps/dev-cpp`         | `myConfig.apps.development.cppTools.*`                                           | C/C++ build systems, caching, quality and debugging tools                                                                                                                             |
| `apps/docker`          | `myConfig.apps.docker.enable`                                                    | Docker and Compose                                                                                                                                                                    |
| `apps/files`           | `myConfig.apps.files.*`                                                          | Backup, sync, VeraCrypt, file search/navigation; opens the Syncthing and LocalSend ports                                                                                              |
| `apps/games`           | `myConfig.apps.games.*`, `myConfig.gui.plasma.games`                             | Steam, emulators, Minecraft, games                                                                                                                                                    |
| `apps/multimedia`      | `myConfig.apps.multimedia.*`                                                     | Video, audio, image and document tools                                                                                                                                                |
| `apps/network-servers` | `myConfig.apps.network.servers.{core,reverseProxy}`                              | Nginx, Caddy, Traefik, HAProxy packages (services stay off)                                                                                                                           |
| `apps/office`          | `myConfig.apps.desktop.{office,printing,printing3d,fonts}`                       | Office suite, notes, printing, 3D printing, a selection of Nerd Fonts                                                                                                                 |
| `apps/torrent`         | `myConfig.apps.network.torrent.*`                                                | qBittorrent, Transmission, helpers; opens their peer ports                                                                                                                            |
| `apps/utilities`       | `myConfig.apps.utilities.*`                                                      | Electronics, flashing, math, maps, system/security tools, antivirus                                                                                                                   |
| `apps/virtualization`  | `myConfig.apps.utilities.{kvm.host,binfmt.enable}`, `myConfig.apps.microvm.host` | KVM/libvirt host, MicroVM host, aarch64-linux binfmt emulation via static qemu-user                                                                   |
