{ ... }:
{
  imports = [
    ./wireless.nix
    ./bluetooth.nix
    ./gpu
    ./cpu
    ./wsl.nix
  ];
}
