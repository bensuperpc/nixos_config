{ ... }:
{
  imports = [
    ./network
    ./nixos
    ./boot.nix
    ./kernel.nix
    ./audio.nix
    ./environment.nix
    ./filesystem.nix
    ./firmware.nix
    ./hardware-tools.nix
    ./locales.nix
    ./tools.nix
    ./power-management.nix
    ./ssh.nix
    ./user.nix
    ./tpm.nix
    ./secureboot.nix
    ./logs.nix
    ./impermanence
    ./snapper.nix
  ];
}
