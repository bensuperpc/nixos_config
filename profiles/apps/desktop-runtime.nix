{ lib, ... }:
{
  myConfig.apps.network.cli.tooling = lib.mkDefault true;
  myConfig.apps.desktop.terminal.enable = lib.mkDefault true;
}
