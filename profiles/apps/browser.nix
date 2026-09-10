{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    #../../tests/check-browser.nix
  ];

  myConfig.apps.network.browser = {
    core = lib.mkDefault true;
    extra = lib.mkDefault true;
    cli = lib.mkDefault true;
  };
}
