{ config, osConfig, lib, pkgs, userVars, ... }:

{
  programs.git = lib.mkIf osConfig.myConfig.apps.development.dev.tooling {
    enable = true;
    lfs.enable = true;
    settings = {
      user = {
        name = "${userVars.fullName}";
        email = "${userVars.email}";
      };
      maintenance = {
        auto = true;
        strategy = "incremental";
      };
      init = {
        defaultBranch = "main";
      };
    };
  };
  home = lib.mkIf osConfig.myConfig.apps.development.cppTools.caching {
    packages = [
      pkgs.ccache
    ];
    sessionVariables = {
      CCACHE_DIR = "$HOME/.cache/ccache";
    };
    activation = {
      setupCcache = config.lib.dag.entryAfter ["writeBoundary"] ''
        mkdir -p $HOME/.cache/ccache
      '';
    };
  };
}