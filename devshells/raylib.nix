{ pkgs, pkgsSets, ... }:

let
  raylib-cpp =
    pkgsSets.unstable.callPackage ../modules/applications/custom/packages/raylib-cpp.nix
      { };
in
pkgs.mkShell {
  nativeBuildInputs = with pkgsSets.unstable; [
    makeWrapper
    pkg-config
  ];
  packages = with pkgsSets.unstable; [
    cmake
    ninja
    gcc
    valgrind
    gdb
    bashInteractive
  ];

  buildInputs = with pkgsSets.unstable; [
    raylib
    raylib-cpp
    gtest
    gbenchmark
  ];

  shellHook = ''
    echo "Welcome to your Nix-managed raylib environment!"
    gcc --version
    pkg-config --modversion raylib
  '';
}
