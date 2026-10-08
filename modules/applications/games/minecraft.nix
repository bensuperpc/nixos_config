{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.games.minecraft;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      launcher = {
        description = "Install Prism Launcher (bundles its own JDKs)";
        packages = with pkgs; [ prismlauncher ];
      };
      tools = {
        description = "Install Minecraft tools";
        packages = with pkgs; [
          mcaselector
          worldpainter
        ];
      };
    };
  };
in
{
  options.myConfig.apps.games.minecraft = generated.options;
  config = lib.mkMerge [
    generated.config
    (lib.mkIf cfg.tools {
      fonts.packages = [ pkgs.minecraftia ];
    })
  ];
}
