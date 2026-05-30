{ config, lib, pkgs, ... }:
{
  imports = [
    ../../tests/check-office.nix
  ];

  myConfig.apps.office = {
    suite = lib.mkDefault true;
    writing = lib.mkDefault true;
    notes = lib.mkDefault true;
  };

  myConfig.apps.printing.service = lib.mkDefault true;
  myConfig.apps.printing3d.tools = lib.mkDefault true;

  myConfig.apps.desktop.fonts.nerdFonts = lib.mkDefault true;
}
