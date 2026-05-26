{ osConfig, lib, ... }:

{
  imports = [
    ./home.nix
    ./plasma.nix
    ./shell.nix
    ./xdg.nix
  ];
}