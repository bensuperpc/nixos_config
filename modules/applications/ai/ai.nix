{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.ai;

  aiPackages = with pkgs; [
    ollama
    ollama-vulkan
    llama-cpp
    llama-cpp-vulkan
  ];

  enabledOptionalsPackages =
    lib.optionals cfg.enable aiPackages;

    anyEnabled = lib.any (x: x) [
      cfg.enable
    ];
in
{
  options.myConfig.apps.ai = {
    enable = moduleHelpers.mkDisabledOption "Install AI tools";
  };

  config = lib.mkMerge [ 
    {
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
    })
  ];
}
