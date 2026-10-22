{ pkgs, cross }:

let
  target = cross.stdenv.hostPlatform;
  toolchain = pkgs.writeText "${target.config}-toolchain.cmake" ''
    set(CMAKE_SYSTEM_NAME Linux)
    set(CMAKE_SYSTEM_PROCESSOR ${target.uname.processor})
    set(CMAKE_C_COMPILER ${cross.stdenv.cc.targetPrefix}gcc)
    set(CMAKE_CXX_COMPILER ${cross.stdenv.cc.targetPrefix}g++)
    set(CMAKE_CROSSCOMPILING_EMULATOR ${pkgs.qemu-user}/bin/qemu-${target.qemuArch})
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
    echo "Welcome to your Nix-managed GCC ${target.config} cross environment!"
    $CXX --version
  '';
}
