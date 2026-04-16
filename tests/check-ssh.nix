# tests/check-openssh.nix
{ config, pkgs, lib, ... }:

let
  requiredSSHPkgs = with pkgs; [
    openssh
    sshfs
  ];
in
{
  assertions =
    [
      {
        assertion = config.services.openssh.enable;
        message = "OpenSSH must be enabled";
      }
      {
        assertion = config.services.fail2ban.enable;
        message = "Fail2Ban must be enabled";
      }
      {
        assertion = config.services.openssh.settings.PasswordAuthentication == false;
        message = "Password authentication must be disabled";
      }
      {
        assertion = config.services.openssh.settings.PermitRootLogin == "no";
        message = "Root login over SSH must be disabled";
      }
      {
        assertion = config.services.openssh.openFirewall;
        message = "OpenSSH firewall opening must be enabled";
      }
      {
        assertion = config.networking.firewall.enable;
        message = "Firewall must be enabled";
      }
      {
        assertion = config.networking.networkmanager.enable;
        message = "NetworkManager must be enabled";
      }
    ]
    ++ map (pkg: {
      assertion = lib.elem pkg config.environment.systemPackages;
      message = "Package missing: ${pkg.name}";
    }) requiredSSHPkgs;
}