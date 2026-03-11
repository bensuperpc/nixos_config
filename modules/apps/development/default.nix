{ pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:
{
  imports = [
    ./dev.nix
    ./ide.nix
    ./libraries.nix
    ./python.nix
    ./modeling.nix
    ./bdd.nix
    ./benchmark.nix
    ./documentation.nix
  ];
}