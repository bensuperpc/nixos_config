{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.utilities.antivirus;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      enable = {
        description = "Install antivirus scanning tools";
        packages = with pkgs; [ clamtk ];
      };
    };
  };
in
{
  options.myConfig.apps.utilities.antivirus = generated.options;
  config = lib.mkMerge [
    generated.config
    (lib.mkIf cfg.enable {
      myConfig.system.impermanence.persistDirectories = [ "/var/lib/clamav" ];
    })
  ];
}
