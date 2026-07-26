{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.multimedia.documents;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      reading = {
        description = "Install e-book reading tools";
        packages = with pkgs; [ calibre ];
      };
      pdf = {
        description = "Install PDF tooling";
        packages = with pkgs; [
          pdfarranger
          pdftk
        ];
      };
    };
  };
in
{
  options.myConfig.apps.multimedia.documents = generated.options;
  inherit (generated) config;
}
