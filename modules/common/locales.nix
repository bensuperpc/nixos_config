{ pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:

{
  # Set your time zone.
  time.timeZone = vars.system.timezone;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = vars.system.layout;
    variant = "";
  };
  console.keyMap = vars.system.layout;

  # Select internationalisation properties.
  i18n.defaultLocale = vars.system.locale;

  i18n.extraLocaleSettings = {
    LC_ADDRESS = vars.system.locale;
    LC_IDENTIFICATION = vars.system.locale;
    LC_MEASUREMENT = vars.system.locale;
    LC_MONETARY = vars.system.locale;
    LC_NAME = vars.system.locale;
    LC_NUMERIC = vars.system.locale;
    LC_PAPER = vars.system.locale;
    LC_TELEPHONE = vars.system.locale;
    LC_TIME = vars.system.locale;
  };
}