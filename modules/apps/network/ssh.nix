{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  cfg = config.myConfig.apps.ssh;

  sshPackages = with pkgs; [
    openssh
    sshfs
  ];
  sshPorts = [ 22 ];

  fail2banIgnoreIP = [
    "192.168.1.0/24"
    "127.0.0.0/8"
  ];
in
{
  options.myConfig.apps.ssh = {
    enable = moduleHelpers.mkDisabledOption "Activate SSH service";

    openFirewall = moduleHelpers.mkEnabledOption "Automatically open port 22 in the firewall.";

    useFail2ban = moduleHelpers.mkEnabledOption "Automatically enable Fail2ban to protect SSH.";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = sshPackages;

    services.openssh = {
      enable = true;
      ports = sshPorts;
      openFirewall = cfg.openFirewall;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    #networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall sshPorts;

    services.fail2ban = lib.mkIf cfg.useFail2ban {
      enable = true;
      maxretry = 5;
      ignoreIP = fail2banIgnoreIP;
      bantime = "24h";
      bantime-increment = {
        enable = true;
        #formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
        multipliers = "1 2 4 8 16 32 64";
        maxtime = "168h";
        overalljails = true;
      };
      # jails = {
      #   apache-nohome-iptables.settings = {
      #     filter = "apache-nohome";
      #     action = ''iptables-multiport[name=HTTP, port="http,https"]'';
      #     logpath = "/var/log/httpd/error_log*";
      #     backend = "auto";
      #     findtime = 600;
      #     bantime  = 600;
      #     maxretry = 5;
      #   };
      # };
    };
  };
}


