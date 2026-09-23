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
    exposePublishedPorts = moduleHelpers.mkDisabledOption "Bind docker port to 127.0.0.1 (you must explicitly bind to 0.0.0.0:PORT to expose a container)";
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
        daemon.settings = lib.mkIf (!cfg.exposePublishedPorts) {
          ip = "127.0.0.1";
        };
      };
    };

    environment.systemPackages = dockerPackages;
  };
}
