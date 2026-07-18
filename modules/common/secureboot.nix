{
  config,
  lib,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.system.secureboot;
in
{
  options.myConfig.system.secureboot = {
    enable = moduleHelpers.mkDisabledOption "Secure Boot via Lanzaboote. Requires sbctl key enrollment on the target machine before the first switch, see README.";

    pkiBundle = lib.mkOption {
      type = lib.types.str;
      default = "/etc/secureboot";
      description = "Path to the sbctl PKI bundle used to sign the Lanzaboote stub and kernel.";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.loader.systemd-boot.enable = lib.mkForce false;

    boot.lanzaboote = {
      enable = true;
      pkiBundle = cfg.pkiBundle;
    };
  };
}
