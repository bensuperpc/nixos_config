{ ... }:
{
  imports = [
    ./ssh.nix
    ./oom.nix
    ./logs.nix
    ./disk-health.nix
    ./power-management.nix
  ];
}
