{ pkgs, inputs, vars, ... }:
{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  imports = [
    ./multimedia
    ./development
    ./docker.nix
    ./compress.nix
    ./games.nix
    ./office.nix
    ./tools.nix
    ./browser.nix
    ./files.nix
    ./math.nix
  ];
}