{
  lib,
  osConfig,
  ...
}:

{
  services.flatpak = lib.mkIf osConfig.myConfig.apps.desktop.flatpak.enable {
    enable = true;
    packages = [
    ];
  };
}
