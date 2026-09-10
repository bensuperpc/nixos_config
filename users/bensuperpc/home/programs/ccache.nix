{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:

{
  home = lib.mkIf osConfig.myConfig.apps.development.cppTools.caching {
    packages = [
      pkgs.ccache
    ];
    sessionVariables = {
      CCACHE_DIR = "$HOME/.cache/ccache";
    };
    activation = {
      setupCcache = config.lib.dag.entryAfter [ "writeBoundary" ] ''
        mkdir -p $HOME/.cache/ccache
      '';
    };
  };
}
