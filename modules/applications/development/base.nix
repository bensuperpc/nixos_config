{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.development.dev;

  basePackages = with pkgs; [
    git
    autoconf
    automake
    binutils
    bison
    debugedit
    fakeroot
    file
    findutils
    flex
    gawk
    gcc
    gettext
    gnugrep
    groff
    gzip
    libtool
    m4
    gnumake
    cmake
    patch
    pkgconf
    gnused
    sudo
    texinfo
    which
    ninja
  ];

  enabledOptionalsPackages =
    lib.optionals cfg.base basePackages;

  anyEnabled = lib.any (x: x) [
    cfg.base
  ];
in
{
  options.myConfig.apps.development.dev = {
    base = moduleHelpers.mkDisabledOption "Install base development system tools";
  };

  config = lib.mkIf anyEnabled {
    environment.systemPackages = enabledOptionalsPackages;
  };
}