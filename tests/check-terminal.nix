# tests/check-terminal.nix
{ config, pkgs, lib, vars, ... }:

let
  requiredPkgs = with pkgs; [
    xterm
    foot
    alacritty-graphics
    alacritty-theme
    wezterm
    terminator
  ];
in
{
  assertions =
    [
      {
        assertion = config.myConfig.apps.terminal.enable;
        message = "Terminal module must be enabled";
      }
    ]
    ++ map (pkg: {
      assertion = lib.elem pkg config.environment.systemPackages;
      message = "Package missing: ${pkg.name}";
    }) requiredPkgs;
}
