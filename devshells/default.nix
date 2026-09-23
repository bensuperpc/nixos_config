{
  pkgs,
  pkgsSets,
  espIdf,
  ...
}:
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
  python2 = import ./python2.nix {
    inherit pkgs pkgsSets;
  };
  rust = import ./rust.nix {
    inherit pkgs pkgsSets;
  };
  java = import ./java.nix {
    inherit pkgs pkgsSets;
  };
  raylib = import ./raylib.nix {
    inherit pkgs pkgsSets;
  };
}
// builtins.listToAttrs (
  map
    (target: {
      name = target;
      value = import ./esp-idf.nix { inherit pkgs espIdf target; };
    })
    [
      "esp32c5"
      "esp32c6"
      "esp32p4"
    ]
)
