{ pkgs }:

let
  raylib-cpp = pkgs.callPackage ../pkgs/raylib-cpp.nix { };
in
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    makeWrapper
    pkg-config
  ];
  packages = with pkgs; [
    cmake
    ninja
    gcc
    valgrind
    gdb
    bashInteractive
  ];

  buildInputs = with pkgs; [
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
