{ pkgs, ... }:

{
  python314 = import ./python314.nix {
    inherit pkgs;
  };
}
