{ pkgs }:

pkgs.mkShell {
  packages = with pkgs; [
    tinycc
    sdcc
    nasm
    byacc
    dtc
    gnumake
  ];

  shellHook = ''
    echo "Welcome to your Nix-managed low-level/embedded environment!"
    sdcc --version | head -n 1
  '';
}
