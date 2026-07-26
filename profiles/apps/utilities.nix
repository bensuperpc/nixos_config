{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    #../../tests/check-math.nix
    #../../tests/check-tools.nix
  ];

  myConfig.apps = {
    electronic = {
      design = lib.mkDefault true;
      diagnostics = lib.mkDefault true;
    };
    flashing.tools = lib.mkDefault true;

    math = {
      geometry = lib.mkDefault true;
      plotting = lib.mkDefault true;
    };
    geography.viewer = lib.mkDefault true;

    tools = {
      system = lib.mkDefault true;
      network = lib.mkDefault true;
      cli = lib.mkDefault true;
      security = lib.mkDefault true;
      archive = lib.mkDefault true;
      crackingPassword = lib.mkDefault true;
    };

    compress = {
      base = lib.mkDefault true;
      tools = lib.mkDefault true;
    };

    antivirus.scanner = lib.mkDefault true;
  };
}
