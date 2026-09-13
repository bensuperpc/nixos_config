{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 10;
    freeMemKillThreshold = 5;
    freeSwapThreshold = 10;
    freeSwapKillThreshold = 5;
    enableNotifications = true;
  };
}
