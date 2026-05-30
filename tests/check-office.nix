# tests/check-office.nix
{ config, pkgs, lib, ... }:

let
  requiredPkgs = with pkgs; [
    # office.suite
    libreoffice-qt-fresh
    # office.writing
    languagetool
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
        assertion = config.myConfig.apps.printing.service;
        message = "Printing service must be enabled";
      }
      {
        assertion = config.myConfig.apps.printing3d.tools;
        message = "3D printing tools must be enabled";
      }
      {
        assertion = config.myConfig.apps.desktop.fonts.nerdFonts;
        message = "NerdFonts must be enabled";
      }
    ]
    ++ map (pkg: {
      assertion = lib.elem pkg config.environment.systemPackages;
      message = "Package missing: ${pkg.name}";
    }) requiredPkgs;
}
