{ pkgs, inputs, vars, ... }:

{
  environment.systemPackages = with pkgs; [
    # office suite
    libreoffice-qt-fresh
    hunspell
    hunspellDicts.fr-any
    hunspellDicts.en_GB-large
    hunspellDicts.en_US-large
    languagetool
  ];

  fonts.fontconfig.enable = true;
}