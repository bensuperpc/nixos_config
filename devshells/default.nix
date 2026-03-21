{ pkgs, inputs', ... }:

{
  python2 = import ./python2.nix {
    inherit pkgs;
  };

  default = import ./python2.nix {
    inherit pkgs;
  };
}
