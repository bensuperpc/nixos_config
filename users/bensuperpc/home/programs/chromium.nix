{
  config,
  osConfig,
  lib,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.chromium;

  chromiumExtensions = [
    "ddkjiahejlhfcafbddmgiahcphecmpfh" # uBlock Origin Lite
    "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
    "neebplgakaahbhdphmkckjjcegoiijjo" # Keepa (amazon price tracker)
    "cimiefiiaegbelhefglklhhakcgmhkai" # Plasma integration
    "fpnmgdkabkmnadcjpehmlllkndpkmiak" # Wayback Machine
    "kdbmhfkmnlmbkgbabkdealhhbfhlmmon" # SteamDB
    # "lclgfmnljgacfdpmmmjmfpdelndbbfhk" # SealSkin Isolation
  ];
in
{
  options.myConfig.apps.chromium.enable =
    moduleHelpers.mkBoolOption osConfig.myConfig.apps.network.browser.core "Chromium with its extensions (follows the system `apps.network.browser.core` toggle by default)";

  config.programs.chromium = lib.mkIf cfg.enable {
    enable = true;
    extensions = chromiumExtensions;
  };
}
