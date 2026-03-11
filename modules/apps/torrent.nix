{ pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:
{
  environment.systemPackages = with pkgs; [
    qbittorrent
    qbittorrent-nox
    transmission_4
  ];
}