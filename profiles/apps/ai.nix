{ ... }:
{
  imports = [
    #../../tests/check-network.nix
    #../../tests/check-terminal.nix
  ];

  myConfig.apps.ai.enable = true;
}