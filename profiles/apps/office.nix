{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    #../../tests/check-office.nix
  ];

  myConfig.apps = {
    office = {
      suite = lib.mkDefault true;
      writing = lib.mkDefault true;
      notes = lib.mkDefault true;
    };

    printing.service = lib.mkDefault true;
    printing3d.tools = lib.mkDefault true;

    desktop.fonts.nerdFonts = lib.mkDefault true;
  };
}
