{ pkgs }:

pkgs.mkShell {
  packages = with pkgs; [
    openjdk21
    maven
    gradle
  ];

  shellHook = ''
    echo "Welcome to your Nix-managed Java environment!"
    java --version
  '';
}
