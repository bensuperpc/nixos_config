{ moduleHelpers, ... }:
{
  # MicroVM examples need per-host secrets: enable them from systems/<host>/configuration.nix.
  myConfig.apps = moduleHelpers.mkDefaults {
    utilities.kvm.host = true;
    microvm.host = true;
  };
}
