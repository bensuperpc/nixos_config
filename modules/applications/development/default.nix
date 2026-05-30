{ config, lib, pkgs, ... }:

{
  imports = [
    ./ide.nix
    ./dev.nix
    ./libraries.nix
    ./qt6.nix
    ./python.nix
    ./modeling.nix
    ./databases.nix
    ./benchmark.nix
    ./documentation.nix
    ./nixtools.nix
    ./cppTools.nix
    ./compilers.nix
    ./rust.nix
    ./go.nix
    ./base.nix
  ];
}
