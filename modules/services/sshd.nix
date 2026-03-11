{ pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:

{
  environment.systemPackages = with pkgs; [
    sshfs
  ];

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };
  networking.firewall.allowedTCPPorts = [ 22 ];

  services.fail2ban = {
    enable = true;
    maxretry = 5;
    ignoreIP = [
      "192.168.1.0/8"
      "127.0.0.0/8"
    ];
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
}
