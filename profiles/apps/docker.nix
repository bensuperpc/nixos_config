{ moduleHelpers, ... }:
{
  myConfig.apps.docker = moduleHelpers.mkDefaults { enable = true; };
}
