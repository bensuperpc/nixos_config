{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.math;

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
    geometry = moduleHelpers.mkDisabledOption "Install geometry and interactive math tools";
    plotting = moduleHelpers.mkDisabledOption "Install mathematical plotting and graphing tools";
  };

  config = lib.mkMerge [
    {
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
    })
  ];
}
