{ config, osConfig, lib, pkgs, userVars, ... }:

let
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
  programs.vscode = lib.mkIf osConfig.myConfig.apps.development.ide.enable {
    enable = true;
    profiles.default.extensions = vscodeExtensions;
  };
}