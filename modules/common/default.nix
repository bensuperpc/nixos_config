{ ... }:
{
  imports = [
    ./network.nix
    ./boot.nix
    ./audio.nix
    ./environment.nix
    ./filesystem.nix
    ./firmware.nix
    ./hardware.nix
    ./locales.nix
    ./nixos.nix
    ./tools.nix
    ./power-management.nix
    ./ssh.nix
  ];
}
