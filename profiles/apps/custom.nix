{ lib, ... }:
{
  myConfig.apps.custom = {
    libraries = lib.mkDefault true;
    # raylib60 = false;
    raylib-cpp = lib.mkDefault true;
    fastnoise2 = lib.mkDefault true;
    libnbtplusplus = lib.mkDefault true;
  };
}
