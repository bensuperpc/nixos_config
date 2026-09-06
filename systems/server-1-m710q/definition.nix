{
  enabled = true;
  role = "full";
  system = "x86_64-linux";
  ip = "192.168.1.26";
  port = 22;

  users = [ "bensuperpc" ];
  deployUser = "bensuperpc";

  appProfiles = [ ];
  platformProfiles = [
    "platform/gpu-intel-skylake"
    "platform/tpm"
    "platform/bluetooth"
    "platform/wireless"
    "platform/snapper"
    "platform/impermanence"
  ];
}
