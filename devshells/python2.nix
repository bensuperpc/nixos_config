{ pkgs }:

let
  # Python 2 is marked insecure
  insecurePkgs = import pkgs.path {
    inherit (pkgs.stdenv.hostPlatform) system;
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [ "python-2.7.18.12" ];
    };
  };
in
insecurePkgs.mkShell {
  packages = [
    insecurePkgs.python2
  ];

  shellHook = ''
    echo "Welcome to your Nix-managed Python 2 environment!"
    python2 --version
  '';
}
