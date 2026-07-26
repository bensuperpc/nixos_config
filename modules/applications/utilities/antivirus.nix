{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.antivirus;
in
{
  options.myConfig.apps.antivirus = {
    scanner = moduleHelpers.mkDisabledOption "Install antivirus scanning tools";
  };

  config = lib.mkIf cfg.scanner {
    environment.systemPackages = with pkgs; [ clamtk ];
  };
}
