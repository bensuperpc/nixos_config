{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.my-docker-compose;
in {
  options.services.my-docker-compose = {
    services = mkOption {
      default = {};
      type = types.attrsOf (types.submodule {
        options = {
          directory = mkOption { type = types.path; };
          ports = mkOption { type = types.listOf types.int; default = []; };
        };
      });
    };
  };

  config = {
    environment.etc = mapAttrs' (name: value: nameValuePair 
      "docker-services/${name}" 
      { source = value.directory; }
    ) cfg.services;

    systemd.services = mapAttrs' (name: value: nameValuePair "docker-compose-${name}" {
      description = "Docker Compose Service: ${name}";
      after = [ "network.target" "docker.service" "docker.socket" ];
      requires = [ "docker.service" "docker.socket" ];
      
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        WorkingDirectory = "/etc/docker-services/${name}";
        ExecStartPre = "${pkgs.docker-compose}/bin/docker-compose down --remove-orphans";
        # ExecStartPre = "${pkgs.docker-compose}/bin/docker-compose pull";
        ExecStart = "${pkgs.docker-compose}/bin/docker-compose up -d --wait";
        ExecStop  = "${pkgs.docker-compose}/bin/docker-compose down";
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
      wantedBy = [ "multi-user.target" ];
    }) cfg.services;

    networking.firewall.allowedTCPPorts = flatten (mapAttrsToList (name: value: value.ports) cfg.services);
  };
}