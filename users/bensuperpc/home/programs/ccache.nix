{
  config,
  osConfig,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.ccache;
in
{
  options.myConfig.apps.ccache.enable =
    moduleHelpers.mkBoolOption osConfig.myConfig.apps.development.cppTools.caching "ccache with a per-user cache directory (follows the system `apps.development.cppTools.caching` toggle by default)";

  config.home = lib.mkIf cfg.enable {
    packages = [
      pkgs.ccache
    ];
    sessionVariables = {
      CCACHE_DIR = "$HOME/.cache/ccache";
    };
    activation = {
      setupCcache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        mkdir -p $HOME/.cache/ccache
      '';
    };
  };
}
