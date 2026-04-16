# tests/check-dev.nix
{ config, pkgs, lib, ... }:

let
  requiredDevPkgs = with pkgs; [
    # compilers.native
    gcc
    clang
    # ctools.buildSystems
    cmake
    mold
    # ctools.caching
    ccache
    # ctools.debugging
    gdb
    # dev.tooling
    clang-tools
    shellcheck
  ];
in
{
  assertions =
    [
      {
        assertion = config.programs.vscode.enable;
        message = "VSCode must be enabled";
      }
      {
        assertion = config.myConfig.apps.development.dev.core;
        message = "Development core group must be enabled";
      }
      {
        assertion = config.myConfig.apps.development.compilers.native;
        message = "Development compilers native group must be enabled";
      }
      {
        assertion = config.myConfig.apps.development.ctools.buildSystems;
        message = "Development ctools build systems group must be enabled";
      }
      {
        assertion = config.myConfig.apps.development.documentation.generators;
        message = "Development documentation generators group must be enabled";
      }
      {
        assertion = config.myConfig.apps.development.nixtools.cache;
        message = "Development nixtools cache group must be enabled";
      }
      {
        assertion = config.myConfig.apps.development.go.toolchain;
        message = "Development Go toolchain group must be enabled";
      }
      {
        assertion = config.myConfig.apps.development.rust.toolchain;
        message = "Development Rust toolchain group must be enabled";
      }
    ]
    ++ map (pkg: {
      assertion = lib.elem pkg config.environment.systemPackages;
      message = "Package missing: ${pkg.name}";
    }) requiredDevPkgs;
}