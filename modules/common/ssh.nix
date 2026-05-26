{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.ssh;

  sshPackages = with pkgs; [
    openssh
    sshfs
  ];
in
{
  options.myConfig.apps.ssh = {
    enable      = moduleHelpers.mkEnabledOption "Activate SSH service";
    openFirewall = moduleHelpers.mkEnabledOption "Automatically open port 22 in the firewall.";
    useFail2ban  = moduleHelpers.mkEnabledOption "Automatically enable Fail2ban to protect SSH.";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = sshPackages;

    services.openssh = {
      enable      = true;
      ports       = lib.mkDefault [ 22 ];
      openFirewall = cfg.openFirewall;
      settings = {
        PasswordAuthentication        = false;
        KbdInteractiveAuthentication  = false;
        PermitRootLogin               = "no";
      };
    };

    services.fail2ban = lib.mkIf cfg.useFail2ban {
      enable    = true;
      maxretry  = 5;
      ignoreIP  = lib.mkDefault [ "127.0.0.0/8" "192.168.1.0/24" ];
      bantime   = "24h";
      bantime-increment = {
        enable      = true;
        multipliers = "1 2 4 8 16 32 64";
        maxtime     = "168h";
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


