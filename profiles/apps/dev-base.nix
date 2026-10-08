{ moduleHelpers, ... }:
{
  myConfig.apps.development.dev = moduleHelpers.mkDefaults { base = true; };
}
