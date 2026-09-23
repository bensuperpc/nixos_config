{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.custom;
  customPackages = import ./packages pkgs;
in
{
  imports = [
    ./overlays/raylib.nix
  ];

  options.myConfig.apps.custom = {
    libraries = moduleHelpers.mkDisabledOption "Install local custom libraries";
    raylib60 = moduleHelpers.mkDisabledOption "Install raylib 6.0 overlay";
    raylib-cpp = moduleHelpers.mkDisabledOption "Install raylib-cpp library";
    fastnoise2 = moduleHelpers.mkDisabledOption "Install FastNoise2 library";
    libnbtplusplus = moduleHelpers.mkDisabledOption "Install libnbtplusplus library";
  };

  config = {
    environment.systemPackages =
      lib.optionals cfg.libraries [
        customPackages.bs-thread-pool
        customPackages.fake-function-framework
      ]
      ++ lib.optional cfg.raylib-cpp customPackages.raylib-cpp
      ++ lib.optional cfg.fastnoise2 customPackages.fastnoise2
      ++ lib.optional cfg.libnbtplusplus customPackages.libnbtplusplus;
  };
}
