{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.desktop.printing;

  cupsDrivers = with pkgs; [
    gutenprint
    # Brother
    brlaser
    brgenml1lpr
    # Samsung
    splix
    # samsung-unified-linux-driver # Non-free
    # Epson
    epson-escpr2
    epson-escpr
    # Lexmark
    postscript-lexmark
    # HP
    hplip
    # hplipWithPlugin # Non-free
  ];
in
{
  options.myConfig.apps.desktop.printing = {
    enable = moduleHelpers.mkDisabledOption "Enable printing services";
  };

  config = lib.mkIf cfg.enable {
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
