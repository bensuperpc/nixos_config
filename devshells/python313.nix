{ pkgs, pkgsSets, ... }:

let
  my-python = pkgsSets.stable-2605.python3.withPackages (
    ps: with ps; [
      pandas
      requests
      fastapi
      uvicorn
    ]
  );
in
pkgs.mkShell {
  packages =
    with pkgsSets.stable-2605;
    [
      ruff
      pyright
      sqlite
      openssl
    ]
    ++ [ my-python ];

  buildInputs = with pkgsSets.stable-2605; [
    # zlib
  ];

  shellHook = ''
    echo "Welcome to your Nix-managed Python environment!"
    python --version
  '';
}
