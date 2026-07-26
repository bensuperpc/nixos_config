{ lib }:

let
  hostSchema = import ../lib/host-schema.nix { inherit lib; };

  hosts = {
    "server-1-m710q" = import ./server-1-m710q/definition.nix;
    "celestia" = import ./celestia/definition.nix;
    "luna" = import ./luna/definition.nix;
    "rainbow-dash" = import ./rainbow-dash/definition.nix;
    "fluttershy" = import ./fluttershy/definition.nix;
    "pinkie-pie" = import ./pinkie-pie/definition.nix;
    "discord-wsl" = import ./discord-wsl/definition.nix;
  };

  # Keep incomplete hosts in inventory files while excluding them from global eval/build.
  activeHosts = lib.filterAttrs (_: host: host.enabled or true) hosts;
in
hostSchema.normalizeHosts activeHosts
