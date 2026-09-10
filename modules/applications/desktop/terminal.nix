{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.desktop.terminal;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      enable = {
        description = "Install additional modern GPU-accelerated terminals";
        packages = with pkgs; [
          alacritty-graphics
          alacritty-theme
          terminator
          wezterm
          foot
          xterm
          kitty
        ];
      };
    };
  };
in
{
  options.myConfig.apps.desktop.terminal = generated.options;
  inherit (generated) config;
}
