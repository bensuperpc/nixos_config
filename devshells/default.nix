{
  pkgsSets,
  espIdf,
  ...
}:
let
  stable = pkgsSets.stable-2605;
  inherit (pkgsSets) unstable;
in
{
  qt6 = import ./qt6.nix { pkgs = stable; };
  gcc = import ./gcc.nix { pkgs = stable; };
  python313 = import ./python313.nix { pkgs = stable; };
  python2 = import ./python2.nix { pkgs = stable; };
  rust = import ./rust.nix { pkgs = stable; };
  java = import ./java.nix { pkgs = stable; };
  raylib = import ./raylib.nix { pkgs = unstable; };
}
// builtins.listToAttrs (
  map
    (target: {
      name = target;
      value = import ./esp-idf.nix {
        pkgs = stable;
        inherit espIdf target;
      };
    })
    [
      "esp32c5"
      "esp32c6"
      "esp32p4"
    ]
)
