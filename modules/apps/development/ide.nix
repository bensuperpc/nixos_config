{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  cfg = config.myConfig.apps.development.ide;
  defaultPackages = with pkgs; [ ];
  idePackages = with pkgs; [
    qtcreator
    helix
  ];
in
{
  options.myConfig.apps.development.ide = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Activate IDE and related tools";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      defaultPackages
      ++ idePackages;

    programs.vscode = {
      enable = true;
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

    hardware.graphics.enable = true;
  };
}

