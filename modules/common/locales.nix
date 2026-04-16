{ config, lib, pkgs, ... }:

{
  # Set your time zone.
  time.timeZone = config.myConfig.vars.system.timezone;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = config.myConfig.vars.system.layout;
    variant = "";
  };
  console.keyMap = config.myConfig.vars.system.layout;

  # Select internationalisation properties.
  i18n = {
    defaultLocale = config.myConfig.vars.system.locale;

    extraLocaleSettings = lib.genAttrs [
      "LC_ADDRESS" "LC_IDENTIFICATION" "LC_MEASUREMENT" "LC_MONETARY"
      "LC_NAME" "LC_NUMERIC" "LC_PAPER" "LC_TELEPHONE" "LC_TIME"
    ] (_: config.myConfig.vars.system.locale);
  };
}