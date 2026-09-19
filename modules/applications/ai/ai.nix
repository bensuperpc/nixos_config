{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.ai;
  llamaCppFixed = pkgs.llama-cpp.override { nodejs_latest = pkgs.nodejs_22; };

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      enable = {
        description = "Install AI tools";
        packages = with pkgs; [
          ollama
          ollama-vulkan
          llamaCppFixed
          (llamaCppFixed.override { vulkanSupport = true; })
        ];
      };
    };
  };
in
{
  options.myConfig.apps.ai = generated.options;
  inherit (generated) config;
}
