{
  enabled = true;
  role = "full";
  system = "x86_64-linux";
  ip = "192.168.1.112";
  port = 22;

  users = [ "bensuperpc" ];
  deployUser = "bensuperpc";

  appProfiles = [ ];
  platformProfiles = [
    "platform/gpu-amd"
    "platform/tpm"
    "platform/bluetooth"
    "platform/wireless"
    "platform/snapper"
    "platform/impermanence"
  ];
}
