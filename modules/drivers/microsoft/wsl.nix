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

    services.resolved.enable = lib.mkForce false; 

    networking.nameservers = lib.mkForce []; 
    networking.nftables.enable = lib.mkForce false; 
    networking.firewall.enable = lib.mkForce false; 
    networking.networkmanager.enable = lib.mkForce false; 

    services.timesyncd.enable = lib.mkForce false;
  };
}

