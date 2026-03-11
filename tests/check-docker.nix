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
        assertion = config.virtualisation.docker.enable;
        message = "Docker must be enabled";
      }
    ]
    ++ map (pkg: {
      assertion = lib.elem pkg config.environment.systemPackages;
      message = "Package missing: ${pkg.name}";
    }) requiredDockerPkgs
    ++ [
      {
        assertion = lib.elem "docker" config.users.users.${vars.admin.name}.extraGroups;
        message = "User must be in docker group";
      }
    ];
}