{ pkgs, inputs, vars, ... }:
{
  imports = [
    ./dev.nix
    ./ide.nix
    ./libraries.nix
  ];
}