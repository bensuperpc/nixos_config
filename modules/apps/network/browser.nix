{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  cfg = config.myConfig.apps.browser;

  basePackages = with pkgs; [
  ];

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
    core = moduleHelpers.mkEnabledOption "Install core browsers";
    extra = moduleHelpers.mkEnabledOption "Install extra browsers";
  };

  config = lib.mkMerge [ 
    {
      environment.systemPackages = basePackages;
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
      hardware.graphics.enable = true;

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


