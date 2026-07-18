{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.development.rust;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      toolchain = {
        description = "Install Rust toolchain";
        packages = with pkgs; [ rustc cargo rustfmt clippy bugstalker uutils-coreutils ];
      };
    };
  };
in
{
  options.myConfig.apps.development.rust = generated.options;
  config = generated.config;
}
