{ pkgsSets, ... }:

let
  pkgs = import pkgsSets.stable-2605.path {
    inherit (pkgsSets.stable-2605) system;
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [ "python-2.7.18.12" ];
    };
  };
in
pkgs.mkShell {
  packages = [
    pkgs.python2
  ];

  shellHook = ''
    echo "Welcome to your Nix-managed Python 2 environment!"
    python2 --version
  '';
}
