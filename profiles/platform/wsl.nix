{ config, lib, ... }:
{
  config.myConfig = {
    drivers.wsl.enable = true;
    apps = {
      firmware.enable = lib.mkForce false;
      ssh = {
        enable = lib.mkForce false;
        openFirewall = lib.mkForce false;
        useFail2ban = lib.mkForce false;
      };
    };
  };
}
