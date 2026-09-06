{
  config,
  lib,
  pkgs,
  pkgsSets,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.development.compilers;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      clang = {
        description = "Install Clang/LLVM toolchains";
        packages = with pkgs; [
          clang
          llvm
          libllvm
        ];
      };
      lowLevel = {
        description = "Install low-level code generation and parser tools";
        packages = with pkgs; [
          byacc
          nasm
          dtc
        ];
      };
      protobuf = {
        description = "Install Protocol Buffers compilers and libraries";
        packages = with pkgs; [
          protobuf
          protobufc
          nanopb
          nanopbMalloc
        ];
      };
      wasm = {
        description = "Install WebAssembly toolchains and runtimes";
        packages = with pkgsSets.stable-2605; [
          emscripten
          wasmi
          wasmer
          emscriptenStdenv
        ];
      };
      embedded = {
        description = "Install embedded and device-oriented compilers";
        packages = with pkgs; [
          tinycc
          sdcc
          linuxHeaders
          musl
        ];
      };
      stdenvs = {
        description = "Install alternate stdenv variants for testing builds";
        packages = with pkgs; [
          clangStdenv
          distccStdenv
          ccacheStdenv
          gccStdenv
        ];
      };
    };
  };
in
{
  options.myConfig.apps.development.compilers = generated.options;
  inherit (generated) config;
}
