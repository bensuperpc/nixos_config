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
      names = lib.attrNames groups;
      enabledPackages = lib.unique (
        lib.concatMap (name: lib.optionals cfg.${name} groups.${name}.packages) names
      );
      anyEnabled = lib.any (name: cfg.${name}) names;
      mkOptionFor =
        group:
        if group.enabledByDefault or false then
          mkEnabledOption group.description
        else
          mkDisabledOption group.description;
    in
    {
      inherit anyEnabled;
      options = lib.mapAttrs (_: mkOptionFor) groups;
      config = lib.mkIf anyEnabled {
        environment.systemPackages = enabledPackages;
      };
    };
in
{
  inherit mkEnabledOption mkDisabledOption mkPackageGroupModule;
}
