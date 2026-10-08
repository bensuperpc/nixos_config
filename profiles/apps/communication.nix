{ moduleHelpers, ... }:
{
  myConfig.apps.network.communication = moduleHelpers.mkDefaults {
    chat = true;
    voice = true;
    mail = true;
    terminal = true;
  };
}
