{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.compress;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      # No packages of its own; kept separate from `tools` in case core
      # compression support (as opposed to the extended tool list below)
      # gets its own package set later.
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
  options.myConfig.apps.compress = generated.options;
  config = generated.config;
}
