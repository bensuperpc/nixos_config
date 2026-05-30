# tests/check-communication.nix
{ config, pkgs, lib, ... }:

let
  requiredPkgs = with pkgs; [
    # communication.chat
    discord
    telegram-desktop
    # communication.voice
    mumble
    # communication.mail
    thunderbird
  ];
in
{
  assertions =
    [
      {
        assertion = config.myConfig.apps.communication.chat;
        message = "Communication chat group must be enabled";
      }
      {
        assertion = config.myConfig.apps.communication.voice;
        message = "Communication voice group must be enabled";
      }
      {
        assertion = config.myConfig.apps.communication.mail;
        message = "Communication mail group must be enabled";
      }
      {
        assertion = config.myConfig.apps.communication.terminal;
        message = "Communication terminal group must be enabled";
      }
    ]
    ++ map (pkg: {
      assertion = lib.elem pkg config.environment.systemPackages;
      message = "Package missing: ${pkg.name}";
    }) requiredPkgs;
}
