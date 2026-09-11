{ pkgs, pkgsSets, ... }:

pkgs.mkShell {
  nativeBuildInputs = with pkgsSets.stable-2605; [
    makeWrapper
  ];
  packages = with pkgsSets.stable-2605; [
    cmake
    ninja
    gcc
    valgrind
    gdb
    ninja
    bashInteractive
  ];

  buildInputs = with pkgsSets.stable-2605; [
    gtest
    gbenchmark
    boost
    openssl
  ];

  shellHook = ''
    echo "Welcome to your Nix-managed GCC environment!"
    gcc --version
  '';
}
