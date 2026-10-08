{ lib, ... }:

{
  time.timeZone = lib.mkDefault "Europe/Paris";

  services.xserver.xkb = {
    layout = lib.mkDefault "fr";
    variant = lib.mkDefault "";
  };
  console.keyMap = lib.mkDefault "fr";

  i18n.defaultLocale = lib.mkDefault "fr_FR.UTF-8";
}
