{ config, lib, pkgs, ... }:
{
  imports = [
    ../../tests/check-math.nix
    ../../tests/check-tools.nix
  ];

  myConfig.apps.electronic = {
    design = lib.mkDefault true;
    diagnostics = lib.mkDefault true;
  };
  myConfig.apps.flashing.tools = lib.mkDefault true;

  myConfig.apps.math = {
    geometry = lib.mkDefault true;
    plotting = lib.mkDefault true;
  };

  myConfig.apps.tools = {
    system = lib.mkDefault true;
    network = lib.mkDefault true;
    cli = lib.mkDefault true;
    security = lib.mkDefault true;
    archive = lib.mkDefault true;
    crackingPassword = lib.mkDefault true;
  };

  myConfig.apps.compress = {
    base = lib.mkDefault true;
    tools = lib.mkDefault true;
  };

  myConfig.apps.antivirus.scanner = lib.mkDefault true;
}
