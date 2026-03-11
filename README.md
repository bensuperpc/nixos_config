# NixOS

This repository contains my NixOS configuration, it is **not perfect** but it is what i use on my machines.

> **⚠️ Warning:** This configuration still in development, it may contain some bugs and issues, use it at your own risk.

## Project Structure

```bash
.
├── drivers # Hardware drivers
├── flake.lock # Flake lock file
├── flake.nix # Flake file and target
├── lib # Custom nix functions
├── Makefile
├── modules
│   ├── apps # Applications
│   │   ├── development # Development tools and libraries
│   │   ├── multimedia # Multimedia applications (Video, audio, image, etc.)
│   │   ├── games # Games and emulators
│   ├── common # common system configuration on every machine (Nix, systemd, etc.)
│   ├── gui # GUI related configuration (Display manager, desktop environment, etc.)
│   └── services # System services (SSH, printing, etc.)
├── profiles # System profiles/presets (Desktop, server, etc.)
├── systems # System specific configuration
├── tests # NixOS tests
├── users # User specific configuration
└── variables # Global variables
```

## Usage

To use this configuration, you can copy all the files to **/etc/nixos**, **add** a new system in `systems*` with your own hardware configuration, then run the following command to build/install the config and then reboot, you have new NixOS configuration:

## Testing

You can test the configuration in a Docker container:

```bash
make server-1-m710q.test
```

To update the flake lock file:

```bash
make update
```

## Deployment

You can use **colmena** to deploy the configuration to your machines

```bash
make server-1-m710q.push
```

## Sources

- [NixOS](https://nixos.org/)
- [NixOS Wiki](https://nixos.wiki/)
- [NixOS Search](https://search.nixos.org/packages)
- [NixOS Options](https://search.nixos.org/options)
- [NixOS Modules](https://search.nixos.org/modules)
- [Nixpkgs PR Tracker](https://nixpk.gs/pr-tracker.html)
- [My NixOS (packages)](https://mynixos.com/)
- [Best of Nix](https://github.com/best-of-lists/best-of)
- [sincorchetes's config](https://github.com/sincorchetes)
- [Secureboot](https://jnsgr.uk/2024/04/nixos-secure-boot-tpm-fde/)
- [CageKiosk](https://github.com/stefansebekow/CageKiosk)
