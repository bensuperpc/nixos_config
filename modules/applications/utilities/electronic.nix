{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.electronic;

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
    design = moduleHelpers.mkDisabledOption "Install electronic design and routing tools";
    diagnostics = moduleHelpers.mkDisabledOption "Install board inspection tools";
  };

  config = lib.mkMerge [
    {
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
    })
  ];
}
