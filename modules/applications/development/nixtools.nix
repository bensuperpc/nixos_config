{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.development.nixtools;


  cachePackages = with pkgs; [
    cachix
  ];
  pinningPackages = with pkgs; [
    niv
    npins
  ];
  analysisPackages = with pkgs; [
    nix-tree
    nix-diff
  ];

  enabledOptionalsPackages =
    lib.optionals cfg.cache cachePackages
    ++ lib.optionals cfg.pinning pinningPackages
    ++ lib.optionals cfg.analysis analysisPackages;

  anyEnabled = lib.any (x: x) [
    cfg.cache
    cfg.pinning
    cfg.analysis
  ];
in
{
  options.myConfig.apps.development.nixtools = {
    cache = moduleHelpers.mkDisabledOption "Install Nix cache and binary cache tools";

    pinning = moduleHelpers.mkDisabledOption "Install Nix pinning and input management tools";

    analysis = moduleHelpers.mkDisabledOption "Install Nix store and derivation inspection tools";
  };

  config = lib.mkMerge [
    {
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
    })
  ];
}
