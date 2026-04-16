{ config, lib, pkgs, ... }:

{
  imports = [
    ./emulator.nix
    ./minecraft.nix
    ./steam.nix
    ./games.nix
  ];
}