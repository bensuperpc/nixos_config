{
  lib,
  ...
}:
{

  myConfig.apps.desktop = {
    office = {
      suite = lib.mkDefault true;
      writing = lib.mkDefault true;
      notes = lib.mkDefault true;
    };

    printing.enable = lib.mkDefault true;
    printing3d.enable = lib.mkDefault true;

    fonts.nerdFonts = lib.mkDefault true;
  };
}
