{ pkgs, inputs, vars, ... }:
{
  environment.systemPackages = with pkgs; [
    xz
    unrar
    unzip
    xdelta
  ];
}