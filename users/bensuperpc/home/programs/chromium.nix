{
  config,
  osConfig,
  lib,
  pkgs,
  userVars,
  ...
}:

let
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
  programs.chromium = lib.mkIf osConfig.myConfig.apps.browser.core {
    enable = true;
    extensions = chromiumExtensions;
  };
}
