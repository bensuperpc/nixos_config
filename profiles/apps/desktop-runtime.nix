{ lib, ... }:
{
  myConfig.apps.network.cli.enable = lib.mkDefault true;
  myConfig.apps.desktop.terminal.enable = lib.mkDefault true;
}
