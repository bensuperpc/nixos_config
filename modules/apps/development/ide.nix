{ pkgs, inputs, vars, ... }:

{
  environment.systemPackages = with pkgs; [
    qtcreator
  ];

  programs.vscode = {
    enable = true;
    defaultEditor = true;
    extensions = with pkgs.vscode-extensions; [
      ms-vscode.cpptools
      ms-vscode.cpptools-extension-pack
      ms-vscode-remote.remote-containers
      ms-vscode.makefile-tools
      ms-azuretools.vscode-docker
      yzhang.markdown-all-in-one
      redhat.vscode-yaml
    ];
  };
}