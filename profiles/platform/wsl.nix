{ lib, ... }:
{
  myConfig = {
    drivers.wsl.enable = true;
    system = {
      firmware.enable = false;
      # No sshd, hence no host key for sops to decrypt with.
      secrets.enable = lib.mkDefault false;
      ssh = {
        enable = false;
        openFirewall = false;
        useFail2ban = false;
      };
    };
  };
}
