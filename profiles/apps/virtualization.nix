{ config, lib, pkgs, ... }:
{
  imports = [
    #../../tests/check-virtualization.nix
  ];

  myConfig.apps.kvm.host = true;
}
