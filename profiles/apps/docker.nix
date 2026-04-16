# profiles/docker.nix — Docker engine (standalone, no server preset).
{ config, lib, pkgs, ... }:
{
  imports = [
    ../../tests/check-docker.nix
  ];

  myConfig.apps.docker.engine = true;
}
