{ lib, moduleHelpers, ... }:

{
  options.myConfig.gui = {
    desktop = lib.mkOption {
      type = lib.types.enum [
        "none"
        "plasma"
        "lxqt"
      ];
      default = "none";
      description = "Desktop environment to use (none, plasma, lxqt).";
    };
    extraPackages = moduleHelpers.mkDisabledOption "Install additional desktop applications and utilities";
  };
}
