{
  config,
  pkgs,
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
        description = "Install Protocol Buffers compilers and code generators";
        packages = with pkgs; [
          protobuf
          protobufc
          nanopb
        ];
      };
      wasm = {
        description = "Install WebAssembly toolchains and runtimes";
        packages = with pkgs; [
          emscripten
          wasmi
          wasmer
        ];
      };
      embedded = {
        description = "Install embedded and device-oriented compilers";
        packages = with pkgs; [
          tinycc
          sdcc
        ];
      };
    };
  };
in
{
  options.myConfig.apps.development.compilers = generated.options;
  inherit (generated) config;
}
