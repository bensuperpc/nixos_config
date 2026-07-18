{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.development.dev;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      base = {
        description = "Install base development system tools";
        packages = with pkgs; [
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
      };
    };
  };
in
{
  options.myConfig.apps.development.dev = generated.options;
  config = generated.config;
}
