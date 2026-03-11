{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:
{
  virtualisation = {
    containers.enable = true;
    docker = {
      enable = true;
      autoPrune.enable = true;
      autoPrune.dates = "weekly";
    };
  };

  environment.systemPackages = lib.mkIf config.virtualisation.docker.enable (with pkgs; [
    docker
    docker-compose
    docker-buildx
    docker-color-output
  ]);
}