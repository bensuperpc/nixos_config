{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.development.modeling;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      engines = {
        description = "Install 3D game engines (Godot, Ogre)";
        packages = with pkgs; [
          godot
          ogre
        ];
      };
      cad = {
        description = "Install 3D modeling and CAD tools (Blender, FreeCAD)";
        packages = with pkgs; [
          blender
          freecad
        ];
      };
    };
  };
in
{
  options.myConfig.apps.development.modeling = generated.options;
  inherit (generated) config;
}
