{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.printing;

  cupsDrivers = with pkgs; [
    gutenprint
    # Brother
    brlaser
    brgenml1lpr
    # HP
    hplip
    # hplipWithPlugin # Non-free
    # Samsung
    splix
    # samsung-unified-linux-driver # Non-free
    # Epson
    epson-escpr2
    epson-escpr
    # Lexmark
    postscript-lexmark
  ];
in
{
  options.myConfig.apps.printing = {
    service = moduleHelpers.mkDisabledOption "Enable printing services";
  };

  config = lib.mkIf cfg.service {
    # services.avahi = {
    #   enable = true;
    #   nssmdns4 = true;
    #   openFirewall = true;
    # };

    # Scanners
    #hardware.sane.enable = true;

    # Enable CUPS to print documents.
    services.printing = {
      enable = true;

      # listenAddresses = [ "*:631" ];
      # allowFrom = [ "all" ];
      # browsing = true;
      # defaultShared = true;
      # openFirewall = true;

      drivers = cupsDrivers;
    };
  };
}
