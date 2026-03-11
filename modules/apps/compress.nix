{ pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:
{
  environment.systemPackages = with pkgs; [
    xz
    unrar
    unzip
    p7zip
    xdelta
    zstd
    gzip
  ];
}