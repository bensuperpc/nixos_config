{ config, lib, pkgs, moduleHelpers, ... }:

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
    svtav1410 = moduleHelpers.mkDisabledOption "Install SVT-AV1 4.1.0 package";
  };

  config = {
    environment.systemPackages = lib.optionals cfg.libraries [
      (pkgs.callPackage packages/bs-thread-pool.nix { })
      (pkgs.callPackage packages/fake-function-framework.nix { })
    ] ++ lib.optionals cfg.svtav1410 [
      (pkgs.callPackage packages/svt-av1.nix { })
    ];
  };

  # nixpkgs.overlays = [
  #   (final: prev: {
  #     lager = prev.lager.override {
  #       boost = pkgs-stable.boost;
  #     };
  #     gource = prev.gource.override {
  #       boost = pkgs-stable.boost;
  #     };
  #   })
  # ];
}