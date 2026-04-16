{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfgg = config.myConfig.apps.hardwareGuiTools;
  cfgc = config.myConfig.apps.hardwareCliTools;

  guiPackages = with pkgs; [
    # Hardware tools/info
    hardinfo2
    hwinfo
    lshw-gui
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
    tools = moduleHelpers.mkDisabledOption "Install hardware GUI tools";
  };

  options.myConfig.apps.hardwareCliTools = {
    tools = moduleHelpers.mkEnabledOption "Install hardware CLI tools";
  };

  config = lib.mkMerge [
    (lib.mkIf cfgg.tools {
      environment.systemPackages = guiPackages;
    })

    (lib.mkIf cfgc.tools {
      environment.systemPackages = cliPackages;
    })
  ];
}
