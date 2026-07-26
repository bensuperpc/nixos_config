{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.development.ide;
in
{
  options.myConfig.apps.development.ide = {
    enable = moduleHelpers.mkDisabledOption "Activate VS Code and IDE tooling";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      vscode
      pragtical
    ];
  };
}
