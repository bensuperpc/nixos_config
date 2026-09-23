{
  config,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.files.crypto;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      enable = {
        description = "Install file encryption tools (VeraCrypt, Cryptomator)";
        packages = with pkgs; [
          veracrypt
          cryptomator
          cryptomator-cli
        ];
      };
    };
  };
in
{
  options.myConfig.apps.files.crypto = generated.options;
  inherit (generated) config;
}
