{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  cfg = config.myConfig.apps.development.compilers;
  basePackages = with pkgs; [ ];
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
    native = moduleHelpers.mkEnabledOption "Install GCC/Clang/LLVM native toolchains";

    lowLevel = moduleHelpers.mkEnabledOption "Install low-level code generation and parser tools";

    wasm = moduleHelpers.mkEnabledOption "Install WebAssembly toolchains and runtimes";

    embedded = moduleHelpers.mkEnabledOption "Install embedded and device-oriented compilers";

    stdenvs = moduleHelpers.mkEnabledOption "Install alternate stdenv variants for testing builds";
  };

  config = lib.mkMerge [
    {
      environment.systemPackages = basePackages;
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
    })
  ];
}
