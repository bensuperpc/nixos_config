{ pkgs, ... }:

let
  python2Pkg =
    if pkgs ? python2 then pkgs.python2
    else if pkgs ? python27 then pkgs.python27
    else throw "No Python 2 package is available in this nixpkgs revision.";
in
pkgs.mkShell {
  name = "python2-shell";

  packages = [ python2Pkg ];

  shellHook = ''
    echo "Python 2 shell ready: $(${python2Pkg}/bin/python --version 2>&1)"
  '';
}
