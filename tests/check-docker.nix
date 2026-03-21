# tests/check-docker.nix
{ config, pkgs, lib, vars, ... }:

let
  requiredDockerPkgs = with pkgs; [
    docker-compose
    docker-buildx
    docker-color-output
  ];
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
        assertion = lib.elem "docker" config.users.users.${vars.admin.user}.extraGroups;
        message = "User must be in docker group";
      }
    ];
}