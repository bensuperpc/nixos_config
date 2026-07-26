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
  nixpkgs.overlays = lib.optionals cfg.raylib60 [
    (_final: prev: {
      raylib = prev.raylib.overrideAttrs (old: {
        version = "6.0";

        src = prev.fetchFromGitHub {
          owner = "raysan5";
          repo = "raylib";
          rev = "386eabb9328fecfd7c285a674fac0c72ff856241";
          hash = "sha256-N+cNQ8tACwgxfCVZTcoYYQQiGPcBKWqaBIXfnlCjb/w=";
        };
        buildInputs = (old.buildInputs or [ ]) ++ [
          prev.libxrandr
        ];
        inherit (old) cmakeFlags;
      });
    })
  ];
}
