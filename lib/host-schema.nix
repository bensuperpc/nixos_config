{ lib, channels }:

let
  rolePresets = import ./role-presets.nix;

  hostModule =
    { name, config, ... }:
    {
      options = {
        enabled = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Include the host in the flake outputs.";
        };
        role = lib.mkOption {
          type = lib.types.enum (lib.attrNames rolePresets);
          default = "minimal";
        };
        system = lib.mkOption { type = lib.types.str; };
        channel = lib.mkOption {
          type = lib.types.enum channels;
          default = "unstable";
          description = "nixpkgs channel (and matching Home Manager release) the host is built from.";
        };
        systemName = lib.mkOption {
          type = lib.types.str;
          default = name;
        };
        ip = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
        };
        port = lib.mkOption {
          type = lib.types.port;
          default = 22;
        };
        users = lib.mkOption {
          type = lib.types.nonEmptyListOf lib.types.str;
          apply = lib.unique;
        };
        deployUser = lib.mkOption {
          type = lib.types.enum config.users;
          default =
            if lib.length config.users == 1 then
              lib.head config.users
            else
              throw "Host '${name}' has multiple users and must define deployUser explicitly.";
        };
        ageRecipient = lib.mkOption {
          type = lib.types.str;
          default = throw "Host '${name}' is missing 'ageRecipient': enroll it in sops (README) or keep enabled = false until then.";
        };
        profiles = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Profiles added to the ones of the role (paths under profiles/, without .nix).";
        };
      };
    };

  normalizeHosts =
    rawHosts:
    let
      evaluated =
        (lib.evalModules {
          modules = [
            {
              options.hosts = lib.mkOption {
                type = lib.types.attrsOf (lib.types.submodule hostModule);
              };
              config.hosts = rawHosts;
            }
          ];
        }).config.hosts;
    in
    lib.mapAttrs (_: host: {
      inherit (host)
        role
        system
        channel
        systemName
        ip
        port
        users
        deployUser
        ageRecipient
        ;
      profiles = lib.unique (rolePresets.${host.role} ++ host.profiles);
    }) (lib.filterAttrs (_: host: host.enabled) evaluated);
in
{
  inherit normalizeHosts;
}
