{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  cfgp = config.myConfig.apps.printing;
  cfgp3 = config.myConfig.apps.printing3d;

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

  printing3dPackages = with pkgs; [
    # 3D printing
    prusa-slicer
    klipper
    pkgs-stable.cura
    pkgs-stable.curaengine
  ];
in
{
  options.myConfig.apps.printing = {
    service = moduleHelpers.mkEnabledOption "Enable printing services";
  };

  options.myConfig.apps.printing3d = {
    tools = moduleHelpers.mkEnabledOption "Install 3D printing tools";
  };

  config = lib.mkMerge [
    {
      environment.systemPackages = with pkgs; [
      ];
    }

    (lib.mkIf cfgp.service {
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
    })

    (lib.mkIf cfgp3.tools {
      environment.systemPackages = printing3dPackages;
    })
  ];
}
