{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.development.compilers;
  
  clangPackages = with pkgs; [
    clang
    llvm
    libllvm
  ];
  lowLevelPackages = with pkgs; [
    byacc
    nasm
    dtc
  ];
  protobufPackages = with pkgs; [
    protobuf
    protobufc
    nanopb
    nanopbMalloc
  ];
  wasmPackages = with pkgs; [
    emscripten
    wasmi
    wasmer
    emscriptenStdenv
  ];
  embeddedPackages = with pkgs; [
    tinycc
    sdcc
    linuxHeaders
    musl
  ];
  stdenvsPackages = with pkgs; [
    clangStdenv
    distccStdenv
    ccacheStdenv
    gccStdenv
  ];

  enabledOptionalsPackages =
    lib.optionals cfg.clang clangPackages
    ++ lib.optionals cfg.lowLevel lowLevelPackages
    ++ lib.optionals cfg.wasm wasmPackages
    ++ lib.optionals cfg.embedded embeddedPackages
    ++ lib.optionals cfg.protobuf protobufPackages
    ++ lib.optionals cfg.stdenvs stdenvsPackages;

  anyEnabled = lib.any (x: x) [
    cfg.clang
    cfg.lowLevel
    cfg.wasm
    cfg.embedded
    cfg.stdenvs
    cfg.protobuf
  ];
in
{
  options.myConfig.apps.development.compilers = {
    clang = moduleHelpers.mkDisabledOption "Install Clang/LLVM toolchains";

    lowLevel = moduleHelpers.mkDisabledOption "Install low-level code generation and parser tools";

    protobuf = moduleHelpers.mkDisabledOption "Install Protocol Buffers compilers and libraries";

    wasm = moduleHelpers.mkDisabledOption "Install WebAssembly toolchains and runtimes";

    embedded = moduleHelpers.mkDisabledOption "Install embedded and device-oriented compilers";

    stdenvs = moduleHelpers.mkDisabledOption "Install alternate stdenv variants for testing builds";
  };

  config = lib.mkMerge [
    {
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
    })
  ];
}
