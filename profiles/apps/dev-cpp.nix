{ moduleHelpers, ... }:
{
  myConfig.apps.development.cppTools = moduleHelpers.mkDefaults {
    caching = true;
    buildSystems = true;
    quality = true;
    debugging = true;
  };
}
