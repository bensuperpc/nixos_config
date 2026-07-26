{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.files.tools;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      search = {
        description = "Install file search and indexing tools";
        packages = with pkgs; [
          fsearch
          catfish
          recoll
          fzf
        ];
      };
      navigation = {
        description = "Install terminal file navigation tools";
        packages = with pkgs; [
          ranger
          nnn
          mc
        ];
      };
    };
  };
in
{
  options.myConfig.apps.files.tools = generated.options;
  inherit (generated) config;
}
