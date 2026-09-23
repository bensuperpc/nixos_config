{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.network.browser;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      core = {
        description = "Install core browsers";
        packages = with pkgs; [ tor-browser ];
      };
      extra = {
        description = "Install extra browsers";
        packages = with pkgs; [
          firefox
          chromium
          ungoogled-chromium
          brave
          # ladybird # CVE-2026-58592
          servo
          librewolf
          dillo
        ];
      };
      cli = {
        description = "Install CLI browsers";
        packages = with pkgs; [
          w3m
          lynx
          # links2 # Broken
          elinks
        ];
      };
    };
  };
in
{
  options.myConfig.apps.network.browser = generated.options;

  config = lib.mkMerge [
    generated.config
    (lib.mkIf cfg.core {
      # Policies only (/etc/chromium/policies): the package and its extensions come from Home Manager.
      programs.chromium = {
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
      };
    })
  ];
}
