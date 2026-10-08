{
  config,
  lib,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.system.tpm;
in
{
  options.myConfig.system.tpm = {
    enable = moduleHelpers.mkDisabledOption "TPM 2.0 support";
  };

  config = lib.mkIf cfg.enable {
    security.tpm2.enable = true;
    boot.initrd.availableKernelModules = [
      "tpm_tis"
      "tpm_crb"
    ];
  };
}
