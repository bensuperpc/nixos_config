{ pkgs }:

pkgs.mkShell {
  packages = with pkgs; [
    cargo
    rustc
    rustfmt
    clippy
    rust-analyzer
    pkg-config
  ];

  shellHook = ''
    echo "Welcome to your Nix-managed Rust environment!"
    rustc --version
    cargo --version
  '';
}
