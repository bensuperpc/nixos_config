# tests/check-productivity.nix
{ config, pkgs, lib, ... }:

let
  requiredProductivityPkgs = with pkgs; [
    # office
    libreoffice-qt-fresh
    languagetool
    logseq
    # communication
    discord
    thunderbird
    mumble
    # electronic
    kicad
    openboardview
  ];
in
{
  assertions =
    [
      {
        assertion = config.myConfig.apps.office.suite;
        message = "Office suite group must be enabled";
      }
      {
        assertion = config.myConfig.apps.office.writing;
        message = "Office writing group must be enabled";
      }
      {
        assertion = config.myConfig.apps.office.notes;
        message = "Office notes group must be enabled";
      }
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
      {
        assertion = config.myConfig.apps.electronic.design;
        message = "Electronic design group must be enabled";
      }
      {
        assertion = config.myConfig.apps.electronic.diagnostics;
        message = "Electronic diagnostics group must be enabled";
      }
    ]
    ++ map (pkg: {
      assertion = lib.elem pkg config.environment.systemPackages;
      message = "Package missing: ${pkg.name}";
    }) requiredProductivityPkgs;
}
