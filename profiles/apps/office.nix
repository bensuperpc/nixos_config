# profiles/office.nix — office suite, printing and fonts.
{ config, lib, pkgs, ... }:
{
  imports = [
    # Tests
    ../../tests/check-productivity.nix
  ];

  myConfig.apps.office = {
    suite = true;
    writing = true;
    notes = true;
  };

  myConfig.apps.printing.service = true;
  myConfig.apps.printing3d.tools = true;

  myConfig.apps.additionalFonts.nerdFonts = true;
}
