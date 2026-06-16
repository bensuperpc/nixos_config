{ config, lib, ... }:
{
  config.myConfig.drivers.wsl.enable = true;
  config.myConfig.apps.firmware.enable = lib.mkForce false;

  config.myConfig.apps.ssh.enable = lib.mkForce false;
  config.myConfig.apps.ssh.openFirewall = lib.mkForce false;
  config.myConfig.apps.ssh.useFail2ban = lib.mkForce false;
}