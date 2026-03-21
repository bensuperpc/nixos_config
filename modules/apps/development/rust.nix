{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  cfg = config.myConfig.apps.development.rust;

  basePackages = with pkgs; [ ];

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
    toolchain = moduleHelpers.mkEnabledOption "Install Rust toolchain";
  };

  config = lib.mkMerge [
    {
      environment.systemPackages = basePackages;
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
    })
  ];
}