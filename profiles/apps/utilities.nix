{ moduleHelpers, ... }:
{
  myConfig.apps.utilities = moduleHelpers.mkDefaults {
    electronic = {
      design = true;
      diagnostics = true;
    };
    flashing.enable = true;

    math = {
      geometry = true;
      plotting = true;
    };
    geography.enable = true;

    tools = {
      system = true;
      network = true;
      cli = true;
      security = true;
      archive = true;
      crackingPassword = true;
    };

    compress.enable = true;

    antivirus.enable = true;
  };
}
