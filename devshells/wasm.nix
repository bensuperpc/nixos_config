{ pkgs }:

pkgs.mkShell {
  packages = with pkgs; [
    emscripten
    wasmi
    wasmer
    cmake
    ninja
  ];

  shellHook = ''
    echo "Welcome to your Nix-managed WebAssembly environment!"
    emcc --version | head -n 1
  '';
}
