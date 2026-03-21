{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  cfg = config.myConfig.apps.files.tools;

  basePackages = with pkgs; [
  ];

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
  mobilePackages = with pkgs; [
    adb-sync
  ];

  enabledOptionalsPackages =
    lib.optionals cfg.search searchPackages
    ++ lib.optionals cfg.navigation navigationPackages
    ++ lib.optionals cfg.mobile mobilePackages;
  
  anyEnabled = lib.any (x: x) [
    cfg.search
    cfg.navigation
    cfg.mobile
  ];
in
{
  options.myConfig.apps.files.tools = {
    search = moduleHelpers.mkEnabledOption "Install file search and indexing tools";
    navigation = moduleHelpers.mkEnabledOption "Install terminal file navigation tools";
    mobile = moduleHelpers.mkEnabledOption "Install mobile device sync helpers";
  };

  config = lib.mkMerge [ 
    {
      environment.systemPackages = basePackages;
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
    })
  ];
}
