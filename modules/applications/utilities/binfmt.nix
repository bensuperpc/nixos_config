{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.utilities.binfmt;
in
{
  options.myConfig.apps.utilities.binfmt = {
    enable = moduleHelpers.mkDisabledOption "Run and build binaries of other architectures through qemu-user";
    systems = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "aarch64-linux" ];
      description = "Systems to emulate, the host system is skipped";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.binfmt = {
      emulatedSystems = lib.remove pkgs.stdenv.hostPlatform.system cfg.systems;
      preferStaticEmulators = true;
    };
  };
}
