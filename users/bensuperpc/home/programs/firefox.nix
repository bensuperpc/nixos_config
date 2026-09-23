{
  config,
  osConfig,
  lib,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.firefox;
in
{
  options.myConfig.apps.firefox.enable =
    moduleHelpers.mkBoolOption osConfig.myConfig.apps.network.browser.core "Firefox with hardened policies (follows the system `apps.network.browser.core` toggle by default)";

  config.programs.firefox = lib.mkIf cfg.enable {
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
