{
  config,
  pkgs,
  moduleHelpers,
  pkgsSets,
  ...
}:

let
  cfg = config.myConfig.apps.multimedia.documents;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      reading = {
        description = "Install e-book reading tools";
        packages = with pkgsSets.stable-2605; [
          calibre
        ];
      };
      pdf = {
        description = "Install PDF tooling";
        packages = with pkgs; [
          pdfarranger
          pdftk
          qpdf
        ];
      };
    };
  };
in
{
  options.myConfig.apps.multimedia.documents = generated.options;
  inherit (generated) config;
}
