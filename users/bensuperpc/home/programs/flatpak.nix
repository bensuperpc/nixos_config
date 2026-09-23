{
  config,
  osConfig,
  lib,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.flatpak;
in
{
  options.myConfig.apps.flatpak.enable =
    moduleHelpers.mkBoolOption osConfig.myConfig.apps.desktop.flatpak.enable "Per-user declarative Flatpak apps (follows the system `apps.desktop.flatpak.enable` toggle by default)";

  config.services.flatpak = lib.mkIf cfg.enable {
    enable = true;
    packages = [
    ];
  };
}
