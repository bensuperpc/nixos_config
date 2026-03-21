{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  cfg = config.myConfig.apps.math;

  basePackages = with pkgs; [ ];

  geometryPackages = with pkgs; [
    geogebra
  ];

  plottingPackages = with pkgs; [
    mathgl
    mathmod
  ];

  enabledOptionalsPackages =
    lib.optionals cfg.geometry geometryPackages
    ++ lib.optionals cfg.plotting plottingPackages;

  anyEnabled = lib.any (x: x) [
    cfg.geometry
    cfg.plotting
  ];
in
{
  options.myConfig.apps.math = {
    geometry = moduleHelpers.mkEnabledOption "Install geometry and interactive math tools";
    plotting = moduleHelpers.mkEnabledOption "Install mathematical plotting and graphing tools";
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
