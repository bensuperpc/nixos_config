{ pkgs, pkgsSets, ... }:
{
  qt6 = import ./qt6.nix {
    inherit pkgs pkgsSets;
  };
  gcc = import ./gcc.nix {
    inherit pkgs pkgsSets;
  };
  python313 = import ./python313.nix {
    inherit pkgs pkgsSets;
  };
  rust = import ./rust.nix {
    inherit pkgs pkgsSets;
  };
  java = import ./java.nix {
    inherit pkgs pkgsSets;
  };
}
