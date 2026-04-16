{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.office;

  suitePackages = with pkgs; [
    libreoffice-qt-fresh
    hyphenDicts.fr-fr
    hyphenDicts.en-us
    hyphenDicts.en-gb
    hunspell
    hunspellDicts.fr-any
    hunspellDicts.en_GB-large
    hunspellDicts.en_US-large
  ];

  writingPackages = with pkgs; [
    languagetool
  ];

  notesPackages = with pkgs; [
    logseq
  ];

  enabledOptionalsPackages =
    lib.optionals cfg.suite suitePackages
    ++ lib.optionals cfg.writing writingPackages
    ++ lib.optionals cfg.notes notesPackages;

  anyEnabled = lib.any (x: x) [
    cfg.suite
    cfg.writing
    cfg.notes
  ];
in
{
  options.myConfig.apps.office = {
    suite = moduleHelpers.mkDisabledOption "Install office suite and dictionaries";
    writing = moduleHelpers.mkDisabledOption "Install writing and grammar tools";
    notes = moduleHelpers.mkDisabledOption "Install note-taking tools";
  };

  config = lib.mkMerge [
    {
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
    })
  ];
}
