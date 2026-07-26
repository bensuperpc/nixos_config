{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    #../../tests/check-docker.nix
  ];

  myConfig.apps.docker.enable = true;
}
