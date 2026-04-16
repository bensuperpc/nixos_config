{
  enabled = false;
  role = "family";
  system = "x86_64-linux";

  users = [ "bensuperpc" ];
  deployUser = "bensuperpc";

  platformProfiles = [ "platform/gpu-intel-skylake" ];
}
