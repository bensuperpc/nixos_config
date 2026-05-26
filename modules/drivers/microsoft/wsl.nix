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

    boot.loader = {
      systemd-boot.enable = lib.mkForce false;
      efi.canTouchEfiVariables = lib.mkForce false;
    };
  };
}

