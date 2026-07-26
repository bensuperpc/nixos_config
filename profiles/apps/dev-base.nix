{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    #../../tests/check-dev.nix
  ];

  myConfig.apps.development.dev = {
    base = lib.mkDefault true;
  };
}
