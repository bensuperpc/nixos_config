{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  cfg = config.myConfig.apps.files;
in
{
  imports = [
    ./backup.nix
    ./sync.nix
    ./crypto.nix
    ./tools.nix
  ];

  options.myConfig.apps.files = {
    enableAll = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Activate all file-related apps and tools";
    };
  };

  config = lib.mkIf cfg.enableAll {
    myConfig.apps.files.backup = {
      core = lib.mkDefault true;
      profileManager = lib.mkDefault true;
      gui = lib.mkDefault true;
    };

    myConfig.apps.files.sync = {
      transfer = lib.mkDefault true;
      peerToPeer = lib.mkDefault true;
      networkShares = lib.mkDefault true;
      mobile = lib.mkDefault true;
    };

    myConfig.apps.files.crypto = {
      veracrypt = lib.mkDefault true;
    };

    myConfig.apps.files.tools = {
      search = lib.mkDefault true;
      navigation = lib.mkDefault true;
      mobile = lib.mkDefault true;
    };

    environment.systemPackages = with pkgs; [
    ];
  };
}
