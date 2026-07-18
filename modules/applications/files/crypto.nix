{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.files.crypto;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      veracrypt = {
        description = "Install VeraCrypt";
        packages = with pkgs; [ veracrypt cryptomator cryptomator-cli ];
      };
    };
  };
in
{
  options.myConfig.apps.files.crypto = generated.options;
  config = generated.config;
}
