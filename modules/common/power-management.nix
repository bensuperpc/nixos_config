{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.powerManagement;
in
{
  options.myConfig.apps = {
    powerManagement.services = moduleHelpers.mkEnabledOption "power management services for desktop/laptop machines";
  };

  config = lib.mkIf cfg.services {
    environment.systemPackages = with pkgs; [
    ];
    services.power-profiles-daemon.enable = true;

    # To avoid conflicts just in case
    services.tuned.enable = false;
    services.tlp.enable = false;
  };
}