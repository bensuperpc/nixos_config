{ pkgs }:

let
  cross = pkgs.pkgsCross.aarch64-multiplatform;
  toolchain = pkgs.writeText "aarch64-toolchain.cmake" ''
    set(CMAKE_SYSTEM_NAME Linux)
    set(CMAKE_SYSTEM_PROCESSOR aarch64)
    set(CMAKE_C_COMPILER ${cross.stdenv.cc.targetPrefix}gcc)
    set(CMAKE_CXX_COMPILER ${cross.stdenv.cc.targetPrefix}g++)
    set(CMAKE_CROSSCOMPILING_EMULATOR ${pkgs.qemu-user}/bin/qemu-aarch64)
    set(Protobuf_PROTOC_EXECUTABLE ${pkgs.protobuf}/bin/protoc)
  '';
in
cross.mkShell {
  nativeBuildInputs = with pkgs; [
    cmake
    ninja
    protobuf
    nanopb
    qemu-user
    cross.buildPackages.gdb
    bashInteractive
  ];

  buildInputs = with cross; [
    gtest
    gbenchmark
    boost
    openssl
    protobuf
    protobufc
  ];

  CMAKE_TOOLCHAIN_FILE = toolchain;

  shellHook = ''
    echo "Welcome to your Nix-managed GCC ARM64 cross environment!"
    $CXX --version
  '';
}
