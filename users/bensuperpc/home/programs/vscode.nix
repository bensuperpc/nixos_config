{
  config,
  osConfig,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.vscode;

  vscodeExtensions = with pkgs.vscode-extensions; [
    ms-vscode.cpptools
    ms-vscode.cpptools-extension-pack
    ms-vscode-remote.remote-containers
    ms-vscode.makefile-tools
    ms-python.python
    ms-azuretools.vscode-docker
    yzhang.markdown-all-in-one
    redhat.vscode-yaml
    jnoortheen.nix-ide
  ];
in
{
  options.myConfig.apps.vscode.enable =
    moduleHelpers.mkBoolOption osConfig.myConfig.apps.development.ide.enable "VS Code with its extensions (follows the system `apps.development.ide.enable` toggle by default)";

  config.programs.vscode = lib.mkIf cfg.enable {
    enable = true;
    profiles.default.extensions = vscodeExtensions;
  };
}
