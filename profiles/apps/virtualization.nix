{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../../tests/check-virtualization.nix
  ];

  myConfig.apps.utilities.kvm.host = true;
  myConfig.apps.microvm = {
    host = true;
    examples = {
      test = true;
    };
  };
}
