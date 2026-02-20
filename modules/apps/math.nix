{ pkgs, inputs, vars, ... }:

{
  environment.systemPackages = with pkgs; [
    # Geometry and graphing
    geogebra
  ];
}