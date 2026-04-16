{ pkgs, ... }:

let
  pythonPkg =
    if pkgs ? python314 then pkgs.python314
    else if pkgs ? python3 then pkgs.python3
    else throw "No Python 3 package is available in this nixpkgs revision.";
in
pkgs.mkShell {
  name = "python314-shell";

  packages = [ pythonPkg ];

  shellHook = ''
    echo "Python 3 shell ready: $(${pythonPkg}/bin/python --version 2>&1)"
  '';
}
