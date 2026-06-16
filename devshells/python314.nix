{ pkgs, pkgsSets, ... }:

let
  my-python = pkgsSets.stable-2605.python3.withPackages (ps: with ps; [
    pandas
    requests
    fastapi
    uvicorn
  ]);
in
pkgs.mkShell {
  packages = [
    my-python
    pkgs.ruff
    pkgs.pyright
    pkgs.sqlite
  ];

  buildInputs = with pkgsSets.stable-2605; [
    # zlib
  ];
  
  shellHook = ''
    echo "Welcome to your Nix-managed Python environment!"
    python --version
  '';
}