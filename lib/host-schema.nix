{ lib }:

let
  rolePresets = import ./role-presets.nix;
  supportedRoles = builtins.attrNames rolePresets;

  # Anything else in a definition.nix file throws an error.
  allowedKeys = [
    "enabled"
    "role"
    "system"
    "systemName"
    "ip"
    "port"
    "users"
    "deployUser"
    "ageRecipient"
    "platformProfiles"
    "appProfiles"
    "policyProfiles"
  ];

  normalizeHost =
    name: raw:
    let
      role = raw.role or "minimal";
      rolePreset =
        rolePresets.${role}
          or (throw "Unknown host role '${role}' for host '${name}'. Supported roles: ${lib.concatStringsSep ", " supportedRoles}");

      unknownKeys = lib.subtractLists allowedKeys (builtins.attrNames raw);

      users = lib.unique (raw.users or [ ]);

      profilesOf = kind: lib.unique ((rolePreset.${kind} or [ ]) ++ (raw.${kind} or [ ]));
      platformProfiles = profilesOf "platformProfiles";
      appProfiles = profilesOf "appProfiles";
      policyProfiles = profilesOf "policyProfiles";
    in
    if unknownKeys != [ ] then
      throw "Host '${name}' has unknown field(s): ${lib.concatStringsSep ", " unknownKeys}. Allowed: ${lib.concatStringsSep ", " allowedKeys}."
    else if !(raw ? system) then
      throw "Host '${name}' is missing required field 'system'."
    else if users == [ ] then
      throw "Host '${name}' has no users. Define users = [ ... ]."
    else if lib.length users > 1 && !(raw ? deployUser) then
      throw "Host '${name}' has multiple users (${lib.concatStringsSep ", " users}) and must define deployUser explicitly."
    else if raw ? deployUser && !(lib.elem raw.deployUser users) then
      throw "Host '${name}': deployUser '${raw.deployUser}' is not in the users list."
    else
      {
        inherit
          role
          users
          platformProfiles
          appProfiles
          policyProfiles
          ;
        allProfiles = lib.unique (platformProfiles ++ appProfiles ++ policyProfiles);
        deployUser = raw.deployUser or (lib.head users);
        ip = raw.ip or null;
        port = raw.port or 22;
        ageRecipient = raw.ageRecipient or null;
        systemName = raw.systemName or name;
        inherit (raw) system;
      };
in
{
  normalizeHosts = lib.mapAttrs normalizeHost;
}
