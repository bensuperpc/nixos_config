# tests/check-gui.nix
{ config, ... }:
{
  assertions = [
    {
      assertion = config.myConfig.gui.desktop == "plasma";
      message = "Platform kde-plasma requires myConfig.gui.desktop = \"plasma\".";
    }
    {
      assertion = config.services.desktopManager.plasma6.enable;
      message = "KDE Plasma 6 desktop manager must be enabled.";
    }
    {
      assertion = config.services.displayManager.plasma-login-manager.enable;
      message = "Plasma login manager must be enabled.";
    }
    {
      assertion = config.services.xserver.enable;
      message = "Xserver must be enabled for KDE Plasma.";
    }
  ];
}
