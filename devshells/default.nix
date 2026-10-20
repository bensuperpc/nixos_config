{
  pkgsSets,
  ...
}:
let
  stable = pkgsSets.stable-2605;
  inherit (pkgsSets) unstable;
in
{
  default = import ./base.nix { pkgs = stable; };
  qt6 = import ./qt6.nix { pkgs = stable; };
  gcc = import ./gcc.nix { pkgs = stable; };
  gcc-arm64 = import ./gcc-arm64.nix { pkgs = stable; };
  clang = import ./clang.nix { pkgs = stable; };
  wasm = import ./wasm.nix { pkgs = stable; };
  embedded = import ./embedded.nix { pkgs = stable; };
  python313 = import ./python313.nix { pkgs = stable; };
  python2 = import ./python2.nix { pkgs = stable; };
  rust = import ./rust.nix { pkgs = stable; };
  java = import ./java.nix { pkgs = stable; };
  raylib = import ./raylib.nix { pkgs = unstable; };
}
