{ pkgs, inputs, vars, ... }:
{
  imports = [
    ./apps
    ./services.nix
    ./environment.nix
    ./nixos.nix
    ./font.nix
    ./locales.nix
    ./networking.nix
    ./gui/kdeplasma.nix
  ];

  environment.systemPackages = [
    (pkgs.callPackage ./custom/lib/bs-thread-pool.nix { })
    (pkgs.callPackage ./custom/lib/fake-function-framework.nix { })
  ];
}