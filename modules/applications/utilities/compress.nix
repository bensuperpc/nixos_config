{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.compress;
  compressPackages = with pkgs; [
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

  enabledOptionalsPackages =
    lib.optionals cfg.tools compressPackages;

  anyEnabled = lib.any (x: x) [
    cfg.base
    cfg.tools
  ];
in
{
  options.myConfig.apps.compress = {
    base = moduleHelpers.mkDisabledOption "Install core compression tools";
    tools = moduleHelpers.mkDisabledOption "Install extended compression tools";
  };

  config = lib.mkMerge [
    {
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
    })
  ];
}
