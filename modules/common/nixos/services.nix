{ config, lib, pkgs, ... }:
{
  # Use dbus-broker as the D-Bus implementation.
  services.dbus.implementation = "broker";

  zramSwap = {
    enable = lib.mkDefault true;
    algorithm = lib.mkDefault "zstd";
    memoryPercent = lib.mkDefault 50;
  };
}