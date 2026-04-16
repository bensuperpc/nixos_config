{ config, lib, pkgs, ... }:

{
  imports = [
    ../../tests/check-common.nix
    ../../tests/check-ssh.nix
  ];

  # Essential CLI and system foundations shared by all profiles.
  myConfig.apps.ssh.enable = true;
}