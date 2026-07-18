# tests/check-lxqt.nix
{ config, ... }:
{
  assertions = [
    {
      assertion = config.myConfig.gui.desktop == "lxqt";
      message = "Platform lxqt requires myConfig.gui.desktop = \"lxqt\".";
    }
    {
      assertion = config.services.xserver.desktopManager.lxqt.enable;
      message = "LXQt desktop manager must be enabled.";
    }
    {
      assertion = config.services.displayManager.sddm.enable;
      message = "SDDM display manager must be enabled for LXQt.";
    }
  ];
}
