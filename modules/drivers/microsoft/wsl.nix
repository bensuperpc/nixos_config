{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.drivers.wsl;
in
{
  options.myConfig.drivers.wsl = {
    enable = moduleHelpers.mkDisabledOption "Enable WSL stack and tools.";
  };

  config = lib.mkIf cfg.enable {
    wsl.enable = true;
    wsl.defaultUser = (lib.head (lib.attrValues config.myConfig.vars.users)).user;

    boot.loader.systemd-boot.enable = lib.mkForce false;
  };
}

