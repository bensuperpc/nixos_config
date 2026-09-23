{ pkgs }:

let
  my-python = pkgs.python3.withPackages (
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
    with pkgs;
    [
      ruff
      pyright
      sqlite
      openssl
    ]
    ++ [ my-python ];

  shellHook = ''
    echo "Welcome to your Nix-managed Python environment!"
    python --version
  '';
}
