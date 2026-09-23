{
  config,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.utilities.hardware;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      gui = {
        description = "Install hardware GUI tools";
        packages = with pkgs; [
          hardinfo2
          hwinfo
          lshw-gui
          # lact # AMD GPU info tool
        ];
      };
      cli = {
        description = "Install hardware CLI tools";
        packages = with pkgs; [
          cpuid
          smartmontools
          inxi
        ];
      };
    };
  };
in
{
  options.myConfig.apps.utilities.hardware = generated.options;
  inherit (generated) config;
}
