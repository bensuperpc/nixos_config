{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  cfg = config.myConfig.apps.development.ctools;
  basePackages = with pkgs; [ ];
  cachingPackages = with pkgs; [
    ccache
    sccache
    distcc
    icecream
  ];
  buildSystemsPackages = with pkgs; [
    gnumake
    cmake
    lomiri.cmake-extras
    meson
    mold
  ];
  qualityPackages = with pkgs; [
    gcovr
    cppcheck
  ];
  debuggingPackages = with pkgs; [
    gdb
    lldb
    ltrace
    valgrind
    binutils
  ];

  enabledOptionalsPackages =
    lib.optionals cfg.caching cachingPackages
    ++ lib.optionals cfg.buildSystems buildSystemsPackages
    ++ lib.optionals cfg.quality qualityPackages
    ++ lib.optionals cfg.debugging debuggingPackages;

  anyEnabled = lib.any (x: x) [
    cfg.caching
    cfg.buildSystems
    cfg.quality
    cfg.debugging
  ];
in
{
  options.myConfig.apps.development.ctools = {
    caching = moduleHelpers.mkEnabledOption "Install compiler cache and distributed build helpers";
    buildSystems = moduleHelpers.mkEnabledOption "Install C/C++ build systems and linkers";
    quality = moduleHelpers.mkEnabledOption "Install code quality and coverage tools";
    debugging = moduleHelpers.mkEnabledOption "Install native debugging and tracing tools";
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
