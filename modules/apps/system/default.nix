{ ... }:
{
  imports = [
    ./boot.nix
    ./environment.nix
    ./filesystem.nix
    ./firmware.nix
    ./hardware.nix
    ./locales.nix
    ./nixos.nix
    ./power-management.nix
    ./networking.nix
  ];
}
