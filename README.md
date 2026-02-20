# NixOS

This repository contains my NixOS configuration, it is **not perfect** but it is what i use on my machines.

## Usage

To use this configuration, you can copy all the files to **/etc/nixos**, **replace** `hosts/hardware-configuration.nix` with your own hardware configuration, then run the following command to build/install the config and then reboot, you have new NixOS configuration:

```bash
sudo nixos-rebuild switch --flake /etc/nixos#nixos
```

## Project Structure

```bash
.
├── drivers # Hardware drivers
├── flake.lock # Flake lock file
├── flake.nix # Flake file
├── lib # Custom nix functions
├── modules
│   ├── apps # Applications
│   └── custom # Custom modules/nix packages
├── README.md
├── systems # System specific configuration
├── users # User specific configuration
├── variables.nix
└── vars # Global variables
```

## Testing

You can test the configuration in a Docker container:

```bash
docker run --rm -v $(pwd):/etc/nixos -w /etc/nixos nixos/nix nix --extra-experimental-features "nix-command flakes"   build .#nixosConfigurations.server-1-m710q.config.system.build.toplevel --dry-run --show-trace --verbose
```

Or:

```bash
docker run --rm -v $(pwd):/etc/nixos -w /etc/nixos nixos/nix nix --extra-experimental-features "nix-command flakes" build path:/etc/nixos#nixosConfigurations.server-1-m710q.config.system.build.toplevel --dry-run --show-trace --verbose
```

## Deployment

You can use **colmena** to deploy the configuration to your machines

```bash
colmena apply --show-trace --verbose
```

or per machine:

```bash
colmena apply --show-trace --verbose --on server-1-m710q
```

Or with **deploy-rs**:

```bash
deploy .#server-1-m710q --skip-checks
```

## Sources

- [NixOS](https://nixos.org/)
- [NixOS Wiki](https://nixos.wiki/)
- [NixOS Search](https://search.nixos.org/packages)
- [NixOS Options](https://search.nixos.org/options)
- [NixOS Modules](https://search.nixos.org/modules)
- [My NixOS (packages)](https://mynixos.com/)
