{ moduleHelpers, ... }:
{
  myConfig.apps.network.browser = moduleHelpers.mkDefaults {
    core = true;
    privacy = true;
    extra = true;
    cli = true;
  };
}
