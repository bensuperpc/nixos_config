{
  enabled = true;
  role = "server";
  system = "x86_64-linux";

  users = [ "bensuperpc" ];
  deployUser = "bensuperpc";

  appProfiles = [ ];
  platformProfiles = [ "platform/gpu-intel-skylake" ];
}
