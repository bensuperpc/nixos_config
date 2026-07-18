{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.electronic;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      design = {
        description = "Install electronic design and routing tools";
        packages = with pkgs; [ kicad ];
      };
      diagnostics = {
        description = "Install board inspection tools";
        packages = with pkgs; [ openboardview ];
      };
    };
  };
in
{
  options.myConfig.apps.electronic = generated.options;
  config = generated.config;
}
