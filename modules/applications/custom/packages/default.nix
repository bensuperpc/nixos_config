# Local packages, shared by the custom app module and the flake checks (built in CI).
pkgs: {
  bs-thread-pool = pkgs.callPackage ./bs-thread-pool.nix { };
  fake-function-framework = pkgs.callPackage ./fake-function-framework.nix { };
  fastnoise2 = pkgs.callPackage ./fastnoise2.nix { };
  libnbtplusplus = pkgs.callPackage ./libnbtplusplus.nix { };
  raylib-cpp = pkgs.callPackage ./raylib-cpp.nix { };
}
