{ lib, ... }:

{
  # Defaults can be overridden per-host directly in systems/<host>/configuration.nix
  # using the standard NixOS options (e.g. time.timeZone = "America/New_York").
  time.timeZone = lib.mkDefault "Europe/Paris";

  services.xserver.xkb = {
    layout  = lib.mkDefault "fr";
    variant = lib.mkDefault "";
  };
  console.keyMap = lib.mkDefault "fr";

  i18n = {
    defaultLocale = lib.mkDefault "fr_FR.UTF-8";

    extraLocaleSettings = lib.genAttrs [
      "LC_ADDRESS" "LC_IDENTIFICATION" "LC_MEASUREMENT" "LC_MONETARY"
      "LC_NAME" "LC_NUMERIC" "LC_PAPER" "LC_TELEPHONE" "LC_TIME"
    ] (_: lib.mkDefault "fr_FR.UTF-8");
  };
}