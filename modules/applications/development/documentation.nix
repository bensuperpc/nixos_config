{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.development.documentation;


  manpagesPackages = with pkgs; [
    man
    stdmanpages
    llvm-manpages
    clang-manpages
    man-pages
    man-pages-posix
    texinfo
  ];
  generatorsPackages = with pkgs; [
    doxygen
    zola
  ];

  enabledOptionalsPackages =
    lib.optionals cfg.manpages manpagesPackages
    ++ lib.optionals cfg.generators generatorsPackages;

  anyEnabled = lib.any (x: x) [
    cfg.manpages
    cfg.generators
  ];
in
{
  options.myConfig.apps.development.documentation = {
    manpages = moduleHelpers.mkDisabledOption "Install manual pages and related documentation sets";

    generators = moduleHelpers.mkDisabledOption "Install documentation generation and static site tools";
  };

  config = lib.mkMerge [
    {
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
    })
  ];
}
