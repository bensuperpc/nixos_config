{ pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:

{
  environment.systemPackages = with pkgs; [
    # office suite
    libreoffice-qt-fresh
    hyphenDicts.fr-fr
    hyphenDicts.en-us
    hyphenDicts.en-gb
    hunspell
    hunspellDicts.fr-any
    hunspellDicts.en_GB-large
    hunspellDicts.en_US-large
    languagetool
    # Markdown note-taking
    logseq
    # LaTeX
    #lyx
  ];
}