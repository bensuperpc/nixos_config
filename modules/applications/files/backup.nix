{ config, lib, pkgs, pkgsSets, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.files.backup;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      core = {
        description = "Install core backup tools";
        packages = with pkgs; [ restic rustic ];
      };
      profileManager = {
        description = "Install backup profile manager";
        packages = [
          (pkgsSets.stable-2605.resticprofile.overrideAttrs (_: { doCheck = false; }))
        ];
      };
      gui = {
        description = "Install backup graphical interface";
        packages = with pkgs; [ restic-browser ];
      };
    };
  };
in
{
  options.myConfig.apps.files.backup = generated.options;
  config = generated.config;
}
