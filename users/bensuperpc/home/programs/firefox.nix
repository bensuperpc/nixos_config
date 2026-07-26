{
  config,
  osConfig,
  lib,
  pkgs,
  userVars,
  ...
}:

{
  programs.firefox = lib.mkIf osConfig.myConfig.apps.browser.core {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    policies = {
      DisableTelemetry = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
    };
  };
}
