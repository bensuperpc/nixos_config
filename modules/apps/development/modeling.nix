{ pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:

{
  environment.systemPackages = with pkgs; [
    # 3D graphics
    godot
    # 3D modeling
    blender
  ];
}