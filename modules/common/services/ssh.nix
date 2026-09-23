{
  config,
  lib,
  pkgs,
  moduleHelpers,
  varsHost,
  ...
}:

let
  cfg = config.myConfig.system.ssh;

  sshPackages = with pkgs; [
    openssh
    sshfs
  ];
in
{
  options.myConfig.system.ssh = {
    enable = moduleHelpers.mkEnabledOption "OpenSSH server (client tools are always installed)";
    openFirewall = moduleHelpers.mkEnabledOption "Open the SSH port in the firewall";
    fail2ban.enable = moduleHelpers.mkEnabledOption "Fail2ban protection for SSH";
  };

  config = lib.mkMerge [
    {
      environment.systemPackages = sshPackages;
      assertions =
        let
          sshd = config.services.openssh;
        in
        lib.optionals sshd.enable [
          {
            assertion =
              sshd.settings.PasswordAuthentication == false
              && sshd.settings.KbdInteractiveAuthentication == false;
            message = "sshd must stay key-only (PasswordAuthentication and KbdInteractiveAuthentication disabled).";
          }
          {
            assertion = sshd.settings.PermitRootLogin == "no";
            message = "sshd must not allow root login (PermitRootLogin = \"no\").";
          }
        ];
    }
    (lib.mkIf cfg.enable {
      services.openssh = {
        enable = true;
        ports = [ varsHost.port ];
        inherit (cfg) openFirewall;
        settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          PermitRootLogin = "no";
        };
      };

      services.fail2ban = lib.mkIf cfg.fail2ban.enable {
        enable = true;
        maxretry = 5;
        ignoreIP = [
          "127.0.0.0/8"
        ];
        bantime = "24h";
        bantime-increment = {
          enable = true;
          multipliers = "1 2 4 8 16 32 64";
          maxtime = "168h";
          overalljails = true;
        };
      };
    })
  ];
}
