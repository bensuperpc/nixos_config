{ config, lib, ... }:
let
  apps = config.myConfig.apps;
in
{
  myConfig.apps.desktop.fonts.enable = lib.mkDefault false;

  # Headless platform: fail if another profile or module pulls in a graphical stack or GUI apps.
  assertions = [
    {
      assertion =
        config.myConfig.gui.desktop == "none"
        && !config.services.xserver.enable
        && !config.services.desktopManager.plasma6.enable
        && !config.services.displayManager.plasma-login-manager.enable
        && !config.services.displayManager.sddm.enable;
      message = "platform/no-gui: a desktop environment or display manager is enabled.";
    }
    {
      assertion =
        !apps.network.browser.core
        && !apps.network.browser.privacy
        && !apps.network.browser.extra
        && !apps.network.communication.chat
        && !apps.network.communication.voice
        && !apps.desktop.office.suite;
      message = "platform/no-gui: GUI applications (browsers, chat, voice, office) must stay disabled.";
    }
  ];
}
