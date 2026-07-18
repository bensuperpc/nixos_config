{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.ai;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      enable = {
        description = "Install AI tools";
        packages = with pkgs; [
          ollama
          ollama-vulkan
          llama-cpp
          llama-cpp-vulkan
        ];
      };
    };
  };
in
{
  options.myConfig.apps.ai = generated.options;
  config = generated.config;
}
