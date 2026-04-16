{ config, lib, pkgs, ... }:
{
  imports = [
    ./backup.nix
    ./sync.nix
    ./crypto.nix
    ./tools.nix
  ];
}
