{ moduleHelpers, ... }:
{
  myConfig.apps.desktop = moduleHelpers.mkDefaults {
    office = {
      suite = true;
      writing = true;
      notes = true;
    };

    printing.enable = true;
    printing3d.enable = true;

    fonts.nerdFonts = true;
  };
}
