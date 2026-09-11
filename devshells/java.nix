{ pkgs, pkgsSets, ... }:

pkgs.mkShell {
  packages = with pkgsSets.stable-2605; [
    openjdk21
    maven
    gradle
  ];

  buildInputs = with pkgsSets.stable-2605; [
    # none
  ];

  shellHook = ''
    echo "Welcome to your Nix-managed Java environment!"
    java --version
  '';
}
