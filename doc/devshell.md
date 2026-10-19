# Development Shells

Defined in `devshells/`, each provides an isolated environment for a specific stack.

```bash
nix develop              # tools for this repository
nix develop .#gcc        # GCC 15 + CMake/GDB/Ninja toolchain
```

| Devshell       | Description                                                                     |
| -------------- | ------------------------------------------------------------------------------- |
| `.#default`    | Colmena, sops, age, ssh-to-age, mkpasswd, jq, linters                           |
| `.#qt6`        | Qt6 + CMake/GCC 15/GDB/Ninja toolchain                                          |
| `.#gcc`        | GCC 15 + CMake/GDB/Ninja toolchain, Protocol Buffers                            |
| `.#clang`      | Clang/LLVM (clangStdenv) + CMake/LLDB/Ninja, lld, clang-tools, Protocol Buffers |
| `.#wasm`       | WebAssembly: Emscripten, wasmi, wasmer                                          |
| `.#embedded`   | Low-level and embedded: tinycc, sdcc, nasm, byacc, dtc                          |
| `.#raylib`     | raylib + raylib-cpp C++ game development environment                            |
| `.#python313`  | Python 3.13 toolchain                                                           |
| `.#python2`    | Python 2 toolchain                                                              |
| `.#rust`       | Rust toolchain (cargo, rustc, clippy, rust-analyzer)                            |
| `.#java`       | Java toolchain (jdk21, maven, gradle)                                           |

Optionally, with `direnv` installed, add a `.envrc` with `use flake .#qt6` and run `direnv allow` to enter the shell automatically when `cd`-ing into the directory.