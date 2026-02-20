{ pkgs, inputs, vars, ... }:
{
  environment.systemPackages = with pkgs; [
    qbittorrent
    qbittorrent-nox
    transmission_4
  ];
}