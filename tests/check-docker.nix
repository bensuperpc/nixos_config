# tests/check-docker.nix
{ config, pkgs, lib, ... }:

let
  requiredDockerPkgs = with pkgs; [
    docker-compose
    docker-buildx
    docker-color-output
  ];
  mainUser =
    if config.myConfig.vars.host.users == [] then null else lib.head config.myConfig.vars.host.users;
in
{
  assertions =
    [
      {
        assertion = config.myConfig.apps.docker.engine;
        message = "Docker engine option must be enabled";
      }
      {
        assertion = config.virtualisation.containers.enable;
        message = "Container support must be enabled";
      }
      {
        assertion = config.virtualisation.docker.enable;
        message = "Docker must be enabled";
      }
      {
        assertion = config.virtualisation.docker.autoPrune.enable;
        message = "Docker auto-prune must be enabled";
      }
    ]
    ++ map (pkg: {
      assertion = lib.elem pkg config.environment.systemPackages;
      message = "Package missing: ${pkg.name}";
    }) requiredDockerPkgs
    ++ [
      {
        assertion = mainUser != null && lib.elem "docker" config.users.users.${mainUser}.extraGroups;
        message = "User must be in docker group";
      }
    ];
}