{ lib, ... }:
{
  myConfig.apps.docker.enable = lib.mkDefault true;
}
