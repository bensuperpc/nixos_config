{ lib, ... }:
{
  # MicroVM examples need per-host secrets: enable them from systems/<host>/configuration.nix.
  myConfig.apps.utilities.kvm.host = lib.mkDefault true;
  myConfig.apps.microvm.host = lib.mkDefault true;
}
