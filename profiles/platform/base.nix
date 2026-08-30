{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    #../../tests/check-common.nix
    ../../tests/check-ssh.nix
  ];

  myConfig.apps.ssh.enable = true;
}
