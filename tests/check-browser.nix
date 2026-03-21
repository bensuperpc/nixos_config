# tests/check-browser.nix
{ config, pkgs, lib, vars, ... }:

let
  requiredBrowserPkgs = with pkgs; [
    # Web browsers
    firefox
    chromium
    tor-browser
  ];
in
{
  assertions =
    [
      {
        assertion = config.myConfig.apps.browser.core;
        message = "Browser core group must be enabled";
      }
      {
        assertion = config.myConfig.apps.browser.extra;
        message = "Browser extra group must be enabled";
      }
      {
        assertion = config.programs.firefox.enable;
        message = "Firefox program must be enabled";
      }
      {
        assertion = config.programs.chromium.enable;
        message = "Chromium program must be enabled";
      }
    ]
    ++ map (pkg: {
      assertion = lib.elem pkg config.environment.systemPackages;
      message = "Package missing: ${pkg.name}";
    }) requiredBrowserPkgs;
}