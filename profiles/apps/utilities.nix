{
  lib,
  ...
}:
{

  myConfig.apps.utilities = {
    electronic = {
      design = lib.mkDefault true;
      diagnostics = lib.mkDefault true;
    };
    flashing.enable = lib.mkDefault true;

    math = {
      geometry = lib.mkDefault true;
      plotting = lib.mkDefault true;
    };
    geography.enable = lib.mkDefault true;

    tools = {
      system = lib.mkDefault true;
      network = lib.mkDefault true;
      cli = lib.mkDefault true;
      security = lib.mkDefault true;
      archive = lib.mkDefault true;
      crackingPassword = lib.mkDefault true;
    };

    compress.enable = lib.mkDefault true;

    antivirus.enable = lib.mkDefault true;
  };
}
