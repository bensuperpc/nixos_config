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
      appProfiles = lib.unique ((rolePreset.appProfiles or [ ]) ++ (raw.appProfiles or [ ]));
      hwProfiles = lib.unique ((rolePreset.hwProfiles or [ ]) ++ (raw.hwProfiles or [ ]));
      policyProfiles = lib.unique ((rolePreset.policyProfiles or [ ]) ++ (raw.policyProfiles or [ ]));

      allProfiles = lib.unique (platformProfiles ++ appProfiles ++ hwProfiles ++ policyProfiles);

      ip = raw.ip or null;
      deployUser = raw.deployUser or (lib.head users);

      hasIntelGpu =
        lib.elem "platform/gpu-intel" hwProfiles
        || lib.elem "platform/gpu-intel-old" hwProfiles
        || lib.elem "platform/gpu-intel-skylake" hwProfiles
        || lib.elem "platform/gpu-intel-xe" hwProfiles;
      hasAmdGpu = lib.elem "platform/gpu-amd" hwProfiles;
    in
    if users == [ ] then
      throw "Host '${name}' has no users. Define users = [ ... ]."
    else if raw ? deployUser && !(lib.elem raw.deployUser users) then
      throw "Host '${name}': deployUser '${raw.deployUser}' is not in the users list."
    else if hasIntelGpu && hasAmdGpu then
      throw "Host '${name}' cannot enable both gpu-intel and gpu-amd profiles."
    else
      {
        inherit role users deployUser platformProfiles appProfiles hwProfiles policyProfiles allProfiles ip;
        systemName = raw.systemName or name;
        system = raw.system;
      };

in {
  inherit rolePresets normalizeHost;

  normalizeHosts = hosts:
    lib.mapAttrs normalizeHost hosts;
}