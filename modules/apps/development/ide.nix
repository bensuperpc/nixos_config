{ pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:

{
  environment.systemPackages = with pkgs; [
    qtcreator
    vim
    nano
  ];

  programs.vscode = {
    enable = true;
    # Nano already default editor
    # defaultEditor = true;
    extensions = with pkgs.vscode-extensions; [
      ms-vscode.cpptools
      ms-vscode.cpptools-extension-pack
      ms-vscode-remote.remote-containers
      ms-vscode.makefile-tools
      ms-python.python
      ms-vscode-remote.remote-containers
      ms-azuretools.vscode-docker
      yzhang.markdown-all-in-one
      redhat.vscode-yaml
    ];
  };
}