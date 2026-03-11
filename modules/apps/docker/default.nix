{ pkgs, ... }:
{
  imports = [ 
    ./docker-services/docker-compose.nix
    ./docker.nix
    ];

  services.my-docker-compose.services = {
    # ollama = {
    #   directory = ./docker-services/docker-ollama;
    #   ports = [ 3000 ];
    # };

    watchtower = {
      directory = ./docker-services/watchtower;
    };
  };
}