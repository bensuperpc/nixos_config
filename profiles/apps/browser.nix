{ config, lib, pkgs, ... }:
{
  imports = [
    #../../tests/check-browser.nix
  ];

  myConfig.apps.browser = {
    core = lib.mkDefault true;
    extra = lib.mkDefault true;
    cli = lib.mkDefault true;
  };
}
