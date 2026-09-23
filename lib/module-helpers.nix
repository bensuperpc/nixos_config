{ lib, ... }:
let
  mkBoolOption =
    default: description:
    lib.mkOption {
      type = lib.types.bool;
      inherit default description;
    };
  mkEnabledOption = mkBoolOption true;
  mkDisabledOption = mkBoolOption false;

  mkPackageGroupModule =
    { cfg, groups }:
    let
      enabledGroups = lib.filter (name: cfg.${name}) (lib.attrNames groups);
      enabledPackages = lib.unique (lib.concatMap (name: groups.${name}.packages or [ ]) enabledGroups);
      anyEnabled = enabledGroups != [ ];
      mkOptionFor = group: mkBoolOption (group.enabledByDefault or false) group.description;
    in
    {
      inherit anyEnabled enabledGroups;
      options = lib.mapAttrs (_: mkOptionFor) groups;
      config = lib.mkIf anyEnabled {
        environment.systemPackages = enabledPackages;
      };
    };
in
{
  inherit
    mkBoolOption
    mkEnabledOption
    mkDisabledOption
    mkPackageGroupModule
    ;
}
