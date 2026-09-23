{
  config,
  lib,
  varsHost,
  ...
}:
let
  cfg = config.myConfig.system.secrets;
  hostSopsFile = ../../../systems + "/${varsHost.name}/secrets.yaml";
  hasHostSopsFile = builtins.pathExists hostSopsFile;
  rolesWithoutSops = [
    "bootstrap"
    "wsl"
  ];
in
{
  options.myConfig.system.secrets.enable = lib.mkOption {
    type = lib.types.bool;
    default = varsHost.ageRecipient != null;
    defaultText = lib.literalExpression "varsHost.ageRecipient != null";
    description = "sops-nix secrets from systems/<host>/secrets.yaml. Defaults to on once the host has an `ageRecipient` in its definition.nix.";
  };

  config = lib.mkMerge [
    {
      assertions = [
        {
          assertion = lib.elem varsHost.role rolesWithoutSops || varsHost.ageRecipient != null;
          message = "Host '${varsHost.name}' (role ${varsHost.role}) has no ageRecipient: enroll it in sops (README) or keep role = \"bootstrap\" until then.";
        }
      ];
    }
    (lib.mkIf cfg.enable {
      sops.defaultSopsFile = lib.mkIf hasHostSopsFile hostSopsFile;

      assertions = [
        {
          assertion =
            hasHostSopsFile
            && varsHost.ageRecipient != null
            && lib.hasInfix "recipient: ${varsHost.ageRecipient}" (builtins.readFile hostSopsFile);
          message = "Host '${varsHost.name}' uses sops but systems/${varsHost.name}/secrets.yaml is missing or not encrypted for its ageRecipient (see README, sops enrollment).";
        }
      ];
    })
  ];
}
