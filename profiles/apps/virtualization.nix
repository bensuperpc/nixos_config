{ moduleHelpers, ... }:
{
  myConfig.apps = moduleHelpers.mkDefaults {
    utilities.kvm.host = true;
    utilities.binfmt.enable = true;
    microvm.host = true;
  };
}
