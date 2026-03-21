{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  cfg = config.myConfig.apps.development.modeling;
  defaultPackages = with pkgs; [ ];
  modelingPackages = with pkgs; [
    # 3D graphics
    godot
    ogre
    # 3D modeling
    blender
    freecad
  ];
in
{
  options.myConfig.apps.development.modeling = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Activate modeling and related tools";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      defaultPackages
      ++ modelingPackages;
    
    hardware.graphics.enable = true;
  };
}
