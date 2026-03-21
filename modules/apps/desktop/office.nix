{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  cfg = config.myConfig.apps.office;

  basePackages = with pkgs; [ ];

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
    suite = moduleHelpers.mkEnabledOption "Install office suite and dictionaries";
    writing = moduleHelpers.mkEnabledOption "Install writing and grammar tools";
    notes = moduleHelpers.mkEnabledOption "Install note-taking tools";
  };

  config = lib.mkMerge [
    {
      environment.systemPackages = basePackages;
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
      hardware.graphics.enable = true;
    })
  ];
}
