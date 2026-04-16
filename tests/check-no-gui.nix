{ config, ... }:

let

in {
  assertions = [
    {
      assertion = !config.myConfig.apps.gui.kdeplasma.enable;
      message = "platform/no-gui conflicts with GUI presets: disable platform/kde-plasma.";
    }
    {
      assertion = !config.services.xserver.enable;
      message = "platform/no-gui: services.xserver.enable must be false (no Xorg allowed).";
    }
    {
      assertion = !config.services.desktopManager.plasma6.enable;
      message = "platform/no-gui: services.desktopManager.plasma6.enable must be false (no Wayland/GUI compositor allowed).";
    }
    {
      assertion = !config.services.displayManager.plasma-login-manager.enable;
      message = "platform/no-gui: services.displayManager.plasma-login-manager.enable must be false.";
    }
    {
      assertion = !config.myConfig.apps.browser.core && !config.myConfig.apps.browser.extra;
      message = "platform/no-gui: browser apps must be disabled (no GUI apps allowed).";
    }
    {
      assertion = !config.myConfig.apps.communication.chat && !config.myConfig.apps.communication.voice;
      message = "platform/no-gui: GUI communication apps (chat, voice) must be disabled.";
    }
    {
      assertion = !config.myConfig.apps.office.suite;
      message = "platform/no-gui: office suite must be disabled (no GUI apps allowed).";
    }
  ];
}
