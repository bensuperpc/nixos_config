{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.development.cppTools;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      caching = {
        description = "Install compiler cache and distributed build helpers";
        packages = with pkgs; [
          ccache
          sccache
          distcc
          icecream
        ];
      };
      buildSystems = {
        description = "Install C/C++ build systems and linkers";
        packages = with pkgs; [
          cmake
          lomiri.cmake-extras
          meson
          mold
          gnumake
        ];
      };
      quality = {
        description = "Install code quality and coverage tools";
        packages = with pkgs; [
          gcovr
          cppcheck
          clang-analyzer
          clang-tools
        ];
      };
      debugging = {
        description = "Install native debugging and tracing tools";
        packages = with pkgs; [
          gdb
          lldb
          ltrace
          valgrind
          libexecinfo
        ];
      };
    };
  };
in
{
  options.myConfig.apps.development.cppTools = generated.options;
  config = lib.mkMerge [
    generated.config
    (lib.mkIf cfg.caching {
      programs.ccache.enable = true;
    })
  ];
}
