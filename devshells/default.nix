{ pkgs, pkgsSets, ... }:
{
  qt6 = import ./qt6.nix { 
    inherit pkgs pkgsSets; 
  };
  python314 = import ./python314.nix {
    inherit pkgs pkgsSets;
  };
}