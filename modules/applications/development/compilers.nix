{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.development.compilers;


  nativePackages = with pkgs; [
    gcc
    libgcc
    clang
    llvm
    libllvm
    binutils
  ];
  lowLevelPackages = with pkgs; [
    byacc
    nasm
    dtc
    protobuf
    protobufc
    nanopb
    nanopbMalloc
  ];
  wasmPackages = with pkgs; [
    emscripten
    wasmi
    #wasmer
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
    gcc15Stdenv
  ];

  enabledOptionalsPackages =
    lib.optionals cfg.native nativePackages
    ++ lib.optionals cfg.lowLevel lowLevelPackages
    ++ lib.optionals cfg.wasm wasmPackages
    ++ lib.optionals cfg.embedded embeddedPackages
    ++ lib.optionals cfg.stdenvs stdenvsPackages;

  anyEnabled = lib.any (x: x) [
    cfg.native
    cfg.lowLevel
    cfg.wasm
    cfg.embedded
    cfg.stdenvs
  ];
in
{
  options.myConfig.apps.development.compilers = {
    native = moduleHelpers.mkDisabledOption "Install GCC/Clang/LLVM native toolchains";

    lowLevel = moduleHelpers.mkDisabledOption "Install low-level code generation and parser tools";

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
