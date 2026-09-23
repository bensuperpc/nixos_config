{ pkgs }:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    makeWrapper
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
