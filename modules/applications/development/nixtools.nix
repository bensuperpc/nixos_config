{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.development.nixtools;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      cache = {
        description = "Install Nix cache and binary cache tools";
        packages = with pkgs; [ cachix ];
      };
      pinning = {
        description = "Install Nix pinning and input management tools";
        packages = with pkgs; [
          niv
          npins
        ];
      };
      analysis = {
        description = "Install Nix store and derivation inspection tools";
        packages = with pkgs; [
          nix-tree
          nix-diff
        ];
      };
    };
  };
in
{
  options.myConfig.apps.development.nixtools = generated.options;
  inherit (generated) config;
}
