# tests/check-math.nix
{ config, pkgs, lib, vars, ... }:

let
  requiredPkgs = with pkgs; [
    # geometry
    geogebra
    # plotting
    mathgl
    mathmod
  ];
in
{
  assertions =
    [
      {
        assertion = config.myConfig.apps.math.geometry;
        message = "Math geometry group must be enabled";
      }
      {
        assertion = config.myConfig.apps.math.plotting;
        message = "Math plotting group must be enabled";
      }
    ]
    ++ map (pkg: {
      assertion = lib.elem pkg config.environment.systemPackages;
      message = "Package missing: ${pkg.name}";
    }) requiredPkgs;
}
