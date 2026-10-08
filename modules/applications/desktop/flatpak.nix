{
  config,
  lib,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.desktop.flatpak;
in
{
  options.myConfig.apps.desktop.flatpak = {
    enable = moduleHelpers.mkBoolOption (
      config.myConfig.gui.desktop != "none"
    ) "Flatpak with declarative app management (nix-flatpak), on by default with a desktop environment";

    packages = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "com.obsproject.Studio"
        "org.videolan.VLC"
      ];
      description = "Flatpak application IDs to install declaratively.";
    };
  };

  config = lib.mkIf cfg.enable {
    myConfig.system.impermanence.persistDirectories = [ "/var/lib/flatpak" ];

    services.flatpak = {
      enable = true;
      update.onActivation = true;
      inherit (cfg) packages;
    };
  };
}
