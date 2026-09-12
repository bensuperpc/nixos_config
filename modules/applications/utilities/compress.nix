{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.utilities.compress;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      base = {
        description = "Install core compression tools";
        packages = [ ];
      };
      tools = {
        description = "Install extended compression tools";
        packages = with pkgs; [
          zip
          unrar
          gnutar
          unzip
          gzip
          lzlib
          lz4
          minizip-ng
          p7zip
        ];
      };
    };
  };
in
{
  options.myConfig.apps.utilities.compress = generated.options;
  inherit (generated) config;
}
