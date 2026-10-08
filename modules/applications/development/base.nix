{
  config,
  pkgs,
  moduleHelpers,
  ...
}:

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
          flex
          gcc
          gettext
          groff
          libtool
          m4
          gnumake
          cmake
          pkgconf
          texinfo
          ninja
        ];
      };
    };
  };
in
{
  options.myConfig.apps.development.dev = generated.options;
  inherit (generated) config;
}
