{ config, lib, pkgs, inputs, moduleHelpers, varsSystem, varsUsers, varsHost, ... }:
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
      readOnly = true;
      internal = true;
      description = "System-level variables";
    };
    users = lib.mkOption {
      type = lib.types.attrsOf lib.types.attrs;
      readOnly = true;
      internal = true;
      description = "Per-user variables";
    };
    host = lib.mkOption {
      type = lib.types.attrs;
      readOnly = true;
      internal = true;
      description = "Host-level variables (name, role, users, deployUser, ip, port)";
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