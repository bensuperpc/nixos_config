# tests/check-video.nix
{ config, pkgs, lib, vars, ... }:

let
  requiredBrowserPkgs = with pkgs; [
    # Web browsers
    firefox
    chromium
    brave
    ladybird
  ];
in
{
  assertions =
    [
    ]
    ++ map (pkg: {
      assertion = lib.elem pkg config.environment.systemPackages;
      message = "Package missing: ${pkg.name}";
    }) requiredBrowserPkgs;
}