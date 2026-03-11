# tests/check-openssh.nix
{ config, pkgs, lib, vars, ... }:

let
  requiredSSHPkgs = with pkgs; [
    openssh
    sshfs
  ];
  requiredTCPPorts = [ 22 ];
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
    ]
    ++ lib.concatMap (port: [
      {
        assertion = lib.elem port config.networking.firewall.allowedTCPPorts;
        message = "Port TCP ${toString port} must be allowed";
      }
    ]) requiredTCPPorts;
}