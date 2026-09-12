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
    enable = moduleHelpers.mkDisabledOption "Enable Flatpak with declarative app management (nix-flatpak)";

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
    services.flatpak = {
      enable = true;
      update.onActivation = true;
      packages = cfg.packages;
    };
  };
}
