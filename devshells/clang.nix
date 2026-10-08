{ pkgs }:

(pkgs.mkShell.override { stdenv = pkgs.clangStdenv; }) {
  nativeBuildInputs = with pkgs; [
    makeWrapper
  ];
  packages = with pkgs; [
    cmake
    ninja
    llvm
    lld
    lldb
    clang-tools
    valgrind
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
    echo "Welcome to your Nix-managed Clang/LLVM environment!"
    clang --version
  '';
}
