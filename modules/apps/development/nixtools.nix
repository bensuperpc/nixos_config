{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  cfg = config.myConfig.apps.development.nixtools;
  basePackages = with pkgs; [ ];
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
    cache = moduleHelpers.mkEnabledOption "Install Nix cache and binary cache tools";

    pinning = moduleHelpers.mkEnabledOption "Install Nix pinning and input management tools";

    analysis = moduleHelpers.mkEnabledOption "Install Nix store and derivation inspection tools";
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
