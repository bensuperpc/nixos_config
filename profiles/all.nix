{ config, lib, pkgs, ... }:
{
  imports = [
    ./platform/base.nix
    ./platform/kde-plasma.nix
    ./apps/games.nix
    ./apps/development.nix
    ./apps/utilities.nix
    ./apps/office.nix
    ./apps/docker.nix
    ./apps/communication.nix
    ./apps/files.nix
    ./apps/desktop.nix
    ./apps/desktop-runtime.nix
    ./apps/multimedia.nix
    ./apps/virtualization.nix
    ./apps/custom.nix
    # Cross-preset integration test (requires office + communication + utilities active).
    ../tests/check-productivity.nix
  ];
}