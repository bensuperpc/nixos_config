{
  config,
  osConfig,
  lib,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.syncthing;
in
{
  options.myConfig.apps.syncthing.enable =
    moduleHelpers.mkBoolOption osConfig.myConfig.apps.files.sync.peerToPeer "Syncthing user service (follows the system `apps.files.sync.peerToPeer` toggle by default)";

  config.services.syncthing = lib.mkIf cfg.enable {
    enable = true;
  };
}
