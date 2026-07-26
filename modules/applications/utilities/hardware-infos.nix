{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfgGui = config.myConfig.apps.hardware.gui;
  cfgCli = config.myConfig.apps.hardware.cli;

  guiPackages = with pkgs; [
    # Hardware tools/info
    hardinfo2
    hwinfo
    lshw-gui
    # lact # AMD GPU info tool
  ];

  cliPackages = with pkgs; [
    # Hardware tools/info
    libtool
    cpuid
    smartmontools
    inxi
    #lshw
    #inxi
  ];

  enabledPackages = lib.optionals cfgGui.tools guiPackages ++ lib.optionals cfgCli.tools cliPackages;
in
{
  options.myConfig.apps.hardware = {
    gui.tools = moduleHelpers.mkDisabledOption "Install hardware GUI tools";
    cli.tools = moduleHelpers.mkDisabledOption "Install hardware CLI tools";
  };

  config = lib.mkMerge [
    {
      environment.systemPackages = enabledPackages;
    }
  ];
}
