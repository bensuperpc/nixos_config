{
  config,
  lib,
  pkgs,
  pkgsSets,
  moduleHelpers,
  ...
}:

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
    # ladybird # CVE-2026-58592
    servo
    librewolf
    dillo
  ];

  cliBrowserPackages = with pkgs; [
    w3m
    lynx
    links2
    elinks
  ];

  enabledOptionalsPackages =
    lib.optionals cfg.core corePackages
    ++ lib.optionals cfg.cli cliBrowserPackages
    ++ lib.optionals cfg.extra extraBrowserPackages;

  anyEnabled = cfg.core || cfg.extra || cfg.cli;
in
{
  options.myConfig.apps.browser = {
    core = moduleHelpers.mkDisabledOption "Install core browsers";
    extra = moduleHelpers.mkDisabledOption "Install extra browsers";
    cli = moduleHelpers.mkDisabledOption "Install CLI browsers";
  };

  config = lib.mkIf anyEnabled {
    environment.systemPackages = enabledOptionalsPackages;

    programs.firefox = lib.mkIf cfg.core {
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

    programs.chromium = lib.mkIf cfg.core {
      enable = true;
      #homepageLocation = "";
      extraOpts = {
        "ExtensionManifestV2Availability" = 2;
        MetricsReportingEnabled = false;
        NewTabPageLocation = "https://github.com/notifications";
        PasswordManagerEnabled = false;
        SpellcheckEnabled = true;
        SpellcheckLanguage = [
          "fr"
          "en-US"
        ];
      };
      # define in home config
      #extensions = [];
    };
  };
}
