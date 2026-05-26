{ config, lib, pkgs, pkgsSets, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.printing3d;

  printing3dPackages = with pkgs; [
    prusa-slicer
    klipper
    # cura
    # curaengine
  ];
in
{
  options.myConfig.apps.printing3d = {
    tools = moduleHelpers.mkDisabledOption "Install 3D printing tools";
  };

  config = lib.mkIf cfg.tools {
    environment.systemPackages = printing3dPackages;
  };
}
