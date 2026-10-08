{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.docker;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      enable = {
        description = "Enable Docker engine and tooling";
        packages = with pkgs; [
          docker
          docker-compose
          docker-buildx
          docker-color-output
          lazydocker
          compose2nix
          dive
        ];
      };
    };
  };
in
{
  options.myConfig.apps.docker = generated.options // {
    exposePublishedPorts = moduleHelpers.mkDisabledOption "Publish container ports on every interface (Docker's default) instead of 127.0.0.1 only";
  };

  config = lib.mkMerge [
    generated.config
    (lib.mkIf cfg.enable {
      myConfig.system.impermanence.persistDirectories = [
        "/var/lib/docker"
        "/var/lib/containers"
      ];

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
    })
  ];
}
