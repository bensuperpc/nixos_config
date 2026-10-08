{
  enabled = false;
  role = "full";
  system = "x86_64-linux";
  ip = "192.168.1.112";
  port = 22;

  users = [ "bensuperpc" ];
  deployUser = "bensuperpc";

  profiles = [
    "platform/gpu-amd"
    "platform/cpu-amd"
    "platform/tpm"
    "platform/bluetooth"
    "platform/snapper"
    "platform/impermanence"
  ];
}
