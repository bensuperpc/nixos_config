{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Use dbus-broker as the D-Bus implementation.
  services.dbus = {
    enable = true;
    implementation = "broker";
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };
}
