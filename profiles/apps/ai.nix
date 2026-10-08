{ moduleHelpers, ... }:
{
  myConfig.apps.ai = moduleHelpers.mkDefaults { enable = true; };
}
