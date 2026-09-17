{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.custom;
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
        (pkgs.callPackage packages/bs-thread-pool.nix { })
        (pkgs.callPackage packages/fake-function-framework.nix { })
      ]
      ++ lib.optionals cfg.raylib-cpp [
        (pkgs.callPackage packages/raylib-cpp.nix { })
      ]
      ++ lib.optionals cfg.fastnoise2 [
        (pkgs.callPackage packages/fastnoise2.nix { })
      ]
      ++ lib.optionals cfg.libnbtplusplus [
        (pkgs.callPackage packages/libnbtplusplus.nix { })
      ];
  };

  # nixpkgs.overlays = [
  #   (final: prev: {
  #     lager = prev.lager.override {
  #       boost = pkgsSets.stable-2605.boost;
  #     };
  #     gource = prev.gource.override {
  #       boost = pkgsSets.stable-2605.boost;
  #     };
  #   })
  # ];
}
