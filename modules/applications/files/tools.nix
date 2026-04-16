{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.files.tools;

  searchPackages = with pkgs; [
    fsearch
    catfish
    recoll
    fzf
  ];
  navigationPackages = with pkgs; [
    ranger
    nnn
    mc
  ];

  enabledOptionalsPackages =
    lib.optionals cfg.search searchPackages
      ++ lib.optionals cfg.navigation navigationPackages;

    anyEnabled = lib.any (x: x) [
      cfg.search
      cfg.navigation
    ];
in
{
  options.myConfig.apps.files.tools = {
    search = moduleHelpers.mkDisabledOption "Install file search and indexing tools";
    navigation = moduleHelpers.mkDisabledOption "Install terminal file navigation tools";
  };

  config = lib.mkMerge [ 
    {
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
    })
  ];
}
