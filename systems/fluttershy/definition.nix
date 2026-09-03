{
  enabled = true;
  role = "server";
  system = "x86_64-linux";
  ip = "192.168.1.32";
  port = 22;

  users = [ "bensuperpc" ];
  deployUser = "bensuperpc";

  appProfiles = [ ];
  platformProfiles = [
    "platform/gpu-intel-skylake"
    "platform/tpm"
  ];
}
