{
  config,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.ai;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      enable = {
        description = "Install AI tools";
        packages = with pkgs; [
          ollama-vulkan
          llama-cpp
        ];
      };
    };
  };
in
{
  options.myConfig.apps.ai = generated.options;
  inherit (generated) config;
}
