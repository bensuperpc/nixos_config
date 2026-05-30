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
}