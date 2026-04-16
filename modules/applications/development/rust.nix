{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.development.rust;

  rustPackages = with pkgs; [
    rustc
    cargo
    rustfmt
    clippy
    bugstalker
    uutils-coreutils
  ];

  enabledOptionalsPackages =
    lib.optionals cfg.toolchain rustPackages;

  anyEnabled = lib.any (x: x) [
    cfg.toolchain
  ];
in
{
  options.myConfig.apps.development.rust = {
    toolchain = moduleHelpers.mkDisabledOption "Install Rust toolchain";
  };

  config = lib.mkMerge [
    {
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
    })
  ];
}