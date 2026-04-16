{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.browser;

  corePackages = with pkgs; [
    firefox
    chromium
    tor-browser
  ];

  extraBrowserPackages = with pkgs; [
    ungoogled-chromium
    brave
    ladybird
    servo
    librewolf
    dillo
  ];

  enabledOptionalsPackages =
    lib.optionals cfg.core corePackages
    ++ lib.optionals cfg.extra extraBrowserPackages;

  anyEnabled = lib.any (x: x) [
    cfg.core
    cfg.extra
  ];
in
{
  options.myConfig.apps.browser = {
    core = moduleHelpers.mkDisabledOption "Install core browsers";
    extra = moduleHelpers.mkDisabledOption "Install extra browsers";
  };

  config = lib.mkMerge [ 
    {
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;

      programs.firefox = {
        enable = true;
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

      programs.chromium = {
        enable = true;
        #homepageLocation = "";
        extraOpts = {
          "ExtensionManifestV2Availability" = 2;
          MetricsReportingEnabled = false;
          NewTabPageLocation = "https://github.com/notifications";
          PasswordManagerEnabled = false;
          SpellcheckEnabled = true;
          SpellcheckLanguage = [ "fr" "en-US" ];
        };
        # define in home config
        #extensions = [];
      };
    })
  ];
}


