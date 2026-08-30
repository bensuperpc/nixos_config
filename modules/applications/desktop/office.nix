{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.office;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      suite = {
        description = "Install office suite and dictionaries";
        packages = with pkgs; [
          libreoffice-qt
          hyphenDicts.fr-fr
          hyphenDicts.en-us
          hyphenDicts.en-gb
          hunspell
          hunspellDicts.fr-any
          hunspellDicts.en_GB-large
          hunspellDicts.en_US-large
        ];
      };
      writing = {
        description = "Install writing and grammar tools";
        packages = with pkgs; [ languagetool ];
      };
      notes = {
        description = "Install note-taking tools";
        packages = with pkgs; [
          # logseq # electron-39 EOL
        ];
      };
    };
  };
in
{
  options.myConfig.apps.office = generated.options;
  inherit (generated) config;
}
