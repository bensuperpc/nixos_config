{ lib }:

let
  hostSchema = import ../lib/host-schema.nix { inherit lib; };

  hosts = {
    "server-1-m710q" = import ./server-1-m710q/definition.nix;
    "celestia"       = import ./celestia/definition.nix;
    "luna"           = import ./luna/definition.nix;
    "rainbow-dash"   = import ./rainbow-dash/definition.nix;
    "fluttershy"     = import ./fluttershy/definition.nix;
    "pinkie-pie"     = import ./pinkie-pie/definition.nix;
  };
in
hostSchema.normalizeHosts hosts
