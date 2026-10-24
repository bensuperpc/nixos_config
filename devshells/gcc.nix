{ pkgs }:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    makeWrapper
  ];
  packages = with pkgs; [
    cmake
    ninja
    gcc
    gbenchmark
    valgrind
    gdb
    protobuf
    protobufc
    nanopb
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
