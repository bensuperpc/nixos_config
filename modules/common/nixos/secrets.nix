{
  lib,
  varsHost,
  ...
}:
let
  hostSopsFile = ../../../systems + "/${varsHost.name}/secrets.yaml";
  hasHostSopsFile = builtins.pathExists hostSopsFile;
in
{
  sops.defaultSopsFile = lib.mkIf hasHostSopsFile hostSopsFile;

  assertions = [
    {
      assertion =
        hasHostSopsFile
        && lib.hasInfix "recipient: ${varsHost.ageRecipient}" (builtins.readFile hostSopsFile);
      message = "Host '${varsHost.name}': systems/${varsHost.name}/secrets.yaml is missing or not encrypted for its ageRecipient (see README, sops enrollment).";
    }
  ];
}
