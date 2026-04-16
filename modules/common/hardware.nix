{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfgGui = config.myConfig.apps.hardware.gui;
  cfgCli = config.myConfig.apps.hardware.cli;

  commonPackages = with pkgs; [
    # Common hardware tools/info
    pciutils
    usbutils
    nvme-cli
    dmidecode
    #lshw
    #inxi
  ];

  guiPackages = with pkgs; [
    # Hardware tools/info
    hardinfo2
    hwinfo
    lshw-gui
    lact
  ];

  cliPackages = with pkgs; [
    # Hardware tools/info
    libtool
    cpuid
    smartmontools
    inxi
  ];
in
{
  options.myConfig.apps.hardware = {
    gui.tools = moduleHelpers.mkDisabledOption "Install hardware GUI tools";
    cli.tools = moduleHelpers.mkEnabledOption "Install hardware CLI tools";
  };

  config = lib.mkMerge [
    (lib.mkIf cfgGui.tools {
      environment.systemPackages = guiPackages;
    })

    (lib.mkIf cfgCli.tools {
      environment.systemPackages = cliPackages;
    })
  ];
}
