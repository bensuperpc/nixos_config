{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  cfgg = config.myConfig.apps.hardwareGuiTools;
  cfgc = config.myConfig.apps.hardwareCliTools;

  guiPackages = with pkgs; [
    # Hardware tools/info
    hardinfo2
    hwinfo
    lshw-gui
    inxi
  ];

  cliPackages = with pkgs; [
    # Hardware tools/info
    pciutils
    usbutils
    libtool
    nvme-cli
    dmidecode
    cpuid
    smartmontools
    inxi
  ];
in
{
  options.myConfig.apps.hardwareGuiTools = {
    tools = moduleHelpers.mkEnabledOption "Install hardware GUI tools";
  };

  options.myConfig.apps.hardwareCliTools = {
    tools = moduleHelpers.mkEnabledOption "Install hardware CLI tools";
  };

  config = lib.mkMerge [
    {
      hardware = {
        graphics = {
          enable = true;
        };
      };

      environment.systemPackages = with pkgs; [
      ];
    }

    (lib.mkIf cfgg.tools {
      environment.systemPackages = guiPackages;
    })

    (lib.mkIf cfgc.tools {
      environment.systemPackages = cliPackages;
    })
  ];
}
