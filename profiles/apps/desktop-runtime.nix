{ ... }:
{
  imports = [
    ../../tests/check-network.nix
    ../../tests/check-terminal.nix
  ];

  myConfig.apps.network.cli.tooling = true;
  myConfig.apps.terminal.enable = true;
}