{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.development.modeling;

  enginesPackages = with pkgs; [
    godot
    ogre
  ];

  modelingPackages = with pkgs; [
    blender
    freecad
  ];

  enabledOptionalsPackages =
    lib.optionals cfg.engines enginesPackages
    ++ lib.optionals cfg.cad modelingPackages;

  anyEnabled = lib.any (x: x) [
    cfg.engines
    cfg.cad
  ];
in
{
  options.myConfig.apps.development.modeling = {
    engines = moduleHelpers.mkDisabledOption "Install 3D game engines (Godot, Ogre)";
    cad = moduleHelpers.mkDisabledOption "Install 3D modeling and CAD tools (Blender, FreeCAD)";
  };

  config = lib.mkMerge [
    {}
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
    })
  ];
}
