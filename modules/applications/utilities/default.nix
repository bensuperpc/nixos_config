{ config, lib, pkgs, ... }:

{
  imports = [
    ./antivirus.nix
    ./compress.nix
    ./electronic.nix
    ./flashing.nix
    ./kvm.nix
    ./math.nix
    ./misc.nix
  ];
}
