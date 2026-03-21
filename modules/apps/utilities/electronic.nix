{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  cfg = config.myConfig.apps.electronic;

  basePackages = with pkgs; [ ];

  designPackages = with pkgs; [
    kicad
  ];

  diagnosticsPackages = with pkgs; [
    openboardview
  ];

  enabledOptionalsPackages =
    lib.optionals cfg.design designPackages
    ++ lib.optionals cfg.diagnostics diagnosticsPackages;

  anyEnabled = lib.any (x: x) [
    cfg.design
    cfg.diagnostics
  ];
in
{
  options.myConfig.apps.electronic = {
    design = moduleHelpers.mkEnabledOption "Install electronic design and routing tools";
    diagnostics = moduleHelpers.mkEnabledOption "Install board inspection tools";
  };

  config = lib.mkMerge [
    {
      environment.systemPackages = basePackages;
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
      hardware.graphics.enable = true;
    })
  ];
}
