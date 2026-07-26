{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.docker;

  dockerPackages = with pkgs; [
    docker
    docker-compose
    docker-buildx
    docker-color-output
    lazydocker
    compose2nix
    dive
  ];
in
{
  options.myConfig.apps.docker = {
    enable = moduleHelpers.mkDisabledOption "Enable Docker engine and tooling";
  };

  config = lib.mkIf cfg.enable {

    virtualisation = {
      containers.enable = true;
      docker = {
        enable = true;
        enableOnBoot = true;
        autoPrune = {
          randomizedDelaySec = "45min";
          enable = true;
          dates = "weekly";
        };
      };
    };

    environment.systemPackages = lib.mkIf config.virtualisation.docker.enable dockerPackages;
  };
}
