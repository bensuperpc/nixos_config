{ ... }:

{
  # First install only: SSH key access + initialPassword, no sops-nix secrets.
  myConfig.system.secrets.enable = false;
}
