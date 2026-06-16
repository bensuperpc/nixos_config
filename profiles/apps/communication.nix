{ config, lib, pkgs, ... }:
{
  imports = [
    #../../tests/check-communication.nix
  ];

  myConfig.apps.communication = {
    chat = lib.mkDefault true;
    voice = lib.mkDefault true;
    mail = lib.mkDefault true;
    terminal = lib.mkDefault true;
  };
}
