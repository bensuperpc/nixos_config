{ moduleHelpers, ... }:
{
  options.myConfig.system.secrets.enable =
    moduleHelpers.mkEnabledOption "sops-nix secrets (disabled by the bootstrap role)";

  config.sops.defaultSopsFile = ../../../secrets/common.yaml;
}
