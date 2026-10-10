{ moduleHelpers, ... }:
{
  myConfig.apps = moduleHelpers.mkDefaults {
    utilities.kvm.host = true;
    microvm.host = true;
  };
}
