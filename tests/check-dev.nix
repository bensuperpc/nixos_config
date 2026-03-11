# tests/check-dev.nix
{ config, pkgs, lib, vars, ... }:

let
  requiredDevPkgs = with pkgs; [
    gcc
    cmake
    ccache
  ];
in
{
  assertions =
    [
      {
        assertion = config.programs.vscode.enable;
        message = "VScode must be enabled";
      }
    ]
    ++ map (pkg: {
      assertion = lib.elem pkg config.environment.systemPackages;
      message = "Package missing: ${pkg.name}";
    }) requiredDevPkgs;
}