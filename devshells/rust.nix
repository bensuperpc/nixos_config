{ pkgs, pkgsSets, ... }:

pkgs.mkShell {
  packages = with pkgsSets.stable-2605; [
    cargo
    rustc
    rustfmt
    clippy
    rust-analyzer
    pkg-config
  ];

  buildInputs = with pkgsSets.stable-2605; [
    # openssl
  ];

  shellHook = ''
    echo "Welcome to your Nix-managed Rust environment!"
    rustc --version
    cargo --version
  '';
}
