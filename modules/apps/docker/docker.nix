{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  cfg = config.myConfig.apps.docker;

  dockerPackages = with pkgs; [
    docker
    docker-compose
    docker-buildx
    docker-color-output
  ];
in
{
  imports = [
    ./docker-services/docker-compose.nix
  ];
  options.myConfig.apps.docker = {
    engine = moduleHelpers.mkEnabledOption "Enable Docker engine and tooling";
  };

  config = lib.mkIf cfg.engine {

    virtualisation = {
      containers.enable = true;
      docker = {
        enable = true;
        autoPrune.enable = true;
        autoPrune.dates = "weekly";
      };
    };

    environment.systemPackages = lib.mkIf config.virtualisation.docker.enable dockerPackages;

    services.my-docker-compose.services = {
      # ollama = {
      #   directory = ./docker-services/docker-ollama;
      #   ports = [ 3000 ];
      # };

      watchtower = {
        directory = ./docker-services/watchtower;
      };
    };
  };
}
