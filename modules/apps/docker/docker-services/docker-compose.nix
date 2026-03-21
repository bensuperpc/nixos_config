{ config, lib, pkgs, ... }:

let
  cfg = config.services.my-docker-compose;

  serviceAfter = [ "network.target" "docker.service" "docker.socket" ];
  serviceRequires = [ "docker.service" "docker.socket" ];
  serviceWantedBy = [ "multi-user.target" ];
in
{
  options.services.my-docker-compose = {
    services = lib.mkOption {
      default = {};
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          directory = lib.mkOption { type = lib.types.path; };
          ports = lib.mkOption { type = lib.types.listOf lib.types.int; default = []; };
        };
      });
    };
  };

  config = {
    environment.etc = lib.mapAttrs' (name: value: lib.nameValuePair
      "docker-services/${name}"
      { source = value.directory; }
    ) cfg.services;

    systemd.services = lib.mapAttrs' (name: value: lib.nameValuePair "docker-compose-${name}" {
      description = "Docker Compose Service: ${name}";
      after = serviceAfter;
      requires = serviceRequires;
      
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        WorkingDirectory = "/etc/docker-services/${name}";
        ExecStartPre = "${pkgs.docker-compose}/bin/docker-compose down --remove-orphans";
        # ExecStartPre = "${pkgs.docker-compose}/bin/docker-compose pull";
        ExecStart = "${pkgs.docker-compose}/bin/docker-compose up -d --wait";
        ExecStop = "${pkgs.docker-compose}/bin/docker-compose down";
        # journalctl -u docker-compose-ollama.service
        # StandardOutput = "journal";
        # StandardError = "journal";
        Restart = "on-failure";
        RestartSec = "10s";
      };
      unitConfig = {
        StartLimitIntervalSec = 60;
        StartLimitBurst = 5;
      };
      wantedBy = serviceWantedBy;
    }) cfg.services;

    networking.firewall.allowedTCPPorts = lib.flatten (lib.mapAttrsToList (name: value: value.ports) cfg.services);
  };
}