{
  enabled = true;
  # Target role "full": switch after sops enrollment (ageRecipient, see README).
  role = "bootstrap";
  system = "x86_64-linux";
  ip = "192.168.1.112";
  port = 22;

  users = [ "bensuperpc" ];
  deployUser = "bensuperpc";

  appProfiles = [ ];
  platformProfiles = [
    "platform/gpu-amd"
    "platform/cpu-amd"
    "platform/tpm"
    "platform/bluetooth"
    "platform/snapper"
    "platform/impermanence"
  ];
}
