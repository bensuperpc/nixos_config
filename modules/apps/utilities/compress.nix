{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  cfg = config.myConfig.apps.compress;
  basePackages = with pkgs; [
    zstd
    p7zip
  ];

  compressPackages = with pkgs; [
    zip
    xz
    unrar
    gnutar
    unzip
    xdelta
    gzip
    lzlib
    lz4
    minizip-ng
  ];

  enabledOptionalsPackages =
    lib.optionals cfg.tools compressPackages;

  anyEnabled = lib.any (x: x) [
    cfg.base
    cfg.tools
  ];
in
{
  options.myConfig.apps.compress = {
    base = moduleHelpers.mkEnabledOption "Install core compression tools";
    tools = moduleHelpers.mkEnabledOption "Install extended compression tools";
  };

  config = lib.mkMerge [
    {
      environment.systemPackages = lib.optionals cfg.base basePackages;
    }

    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
    })
  ];
}
