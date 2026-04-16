{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, varsSystem, varsUsers, varsHost, ... }:
{
  imports = [
    ./common
    ./drivers
    ./gui
    ./applications
  ];

  options.myConfig.vars = {
    system = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "System-level variables";
    };
    users = lib.mkOption {
      type = lib.types.attrsOf lib.types.attrs;
      default = {};
      description = "Per-user variables";
    };
    host = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Host-level variables (name, role, users)";
    };
  };

  config = {
    myConfig.vars = {
      system = varsSystem.system;
      users = varsUsers;
      host = varsHost;
    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;
  };
}