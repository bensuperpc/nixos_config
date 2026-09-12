{
  config,
  lib,
  pkgs,
  ...
}:
{

  myConfig.apps.development.dev = {
    base = lib.mkDefault true;
  };
}
