{ lib }:

let
  rolePresets = import ./role-presets.nix;

  normalizeHost = name: raw:
    let
      role = raw.role or "minimal";
      supportedRoles = builtins.attrNames rolePresets;
      rolePreset =
        if lib.hasAttr role rolePresets then
          rolePresets.${role}
        else
          throw "Unknown host role '${role}' for host '${name}'. Supported roles: ${lib.concatStringsSep ", " supportedRoles}";

      users = lib.unique (raw.users or [ ]);

      platformProfiles = lib.unique ((rolePreset.platformProfiles or [ ]) ++ (raw.platformProfiles or [ ]));
      appProfiles      = lib.unique ((rolePreset.appProfiles or [ ])      ++ (raw.appProfiles or [ ]));
      policyProfiles   = lib.unique ((rolePreset.policyProfiles or [ ])   ++ (raw.policyProfiles or [ ]));

      allProfiles = lib.unique (platformProfiles ++ appProfiles ++ policyProfiles);

      ip         = raw.ip or null;
      port       = raw.port or 22;
      enabled    = raw.enabled or true;
      deployUser = raw.deployUser or (lib.head users);
    in
    if !(raw ? system) then
      throw "Host '${name}' is missing required field 'system'."
    else if users == [ ] then
      throw "Host '${name}' has no users. Define users = [ ... ]."
    else if lib.length users > 1 && !(raw ? deployUser) then
      throw "Host '${name}' has multiple users (${lib.concatStringsSep ", " users}) and must define deployUser explicitly."
    else if raw ? deployUser && !(lib.elem raw.deployUser users) then
      throw "Host '${name}': deployUser '${raw.deployUser}' is not in the users list."
    else
      {
        inherit role users deployUser platformProfiles appProfiles policyProfiles allProfiles ip port enabled;
        systemName = raw.systemName or name;
        system = raw.system;
      };

in {
  inherit rolePresets normalizeHost;

  normalizeHosts = hosts:
    lib.mapAttrs normalizeHost hosts;
}