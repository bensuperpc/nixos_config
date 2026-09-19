{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:
{
  networking.firewall = rec {
    allowedTCPPortRanges =
      [ ]
      ++ lib.optionals (config.myConfig.gui.desktop == "plasma") [
        {
          from = 1714;
          to = 1764;
        }
      ];
    allowedUDPPortRanges = allowedTCPPortRanges;
  };
}
