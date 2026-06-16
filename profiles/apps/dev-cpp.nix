{ config, lib, pkgs, ... }:
{
  imports = [
    #../../tests/check-dev.nix
  ];
  myConfig.apps.development.cppTools = {
    caching = lib.mkDefault true;
    buildSystems = lib.mkDefault true;
    quality = lib.mkDefault true;
    debugging = lib.mkDefault true;
  };
}
