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
      tools = lib.mkDefault true;
    };

    antivirus.scanner = lib.mkDefault true;
  };
}
