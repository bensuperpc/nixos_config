{ config, lib, pkgs, ... }:

{
  imports = [
    ./ide.nix
    ./dev.nix
    ./libraries.nix
    ./qt6.nix
    ./python.nix
    ./modeling.nix
    ./bdd.nix
    ./benchmark.nix
    ./documentation.nix
    ./nixtools.nix
    ./ctools.nix
    ./compilers.nix
    ./rust.nix
    ./go.nix
  ];
}
