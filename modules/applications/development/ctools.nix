{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.development.ctools;


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
    caching = moduleHelpers.mkDisabledOption "Install compiler cache and distributed build helpers";
    buildSystems = moduleHelpers.mkDisabledOption "Install C/C++ build systems and linkers";
    quality = moduleHelpers.mkDisabledOption "Install code quality and coverage tools";
    debugging = moduleHelpers.mkDisabledOption "Install native debugging and tracing tools";
  };

  config = lib.mkMerge [
    {
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
    })
    (lib.mkIf cfg.caching {
      programs.ccache.enable = true;
    })
  ];
}
