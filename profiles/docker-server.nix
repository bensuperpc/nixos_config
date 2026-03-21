# profiles/docker-server.nix
{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

{
  imports = [
    ./base.nix
    # Tests
    ../tests/check-docker.nix
  ];

  myConfig.apps.docker.engine = true;
}