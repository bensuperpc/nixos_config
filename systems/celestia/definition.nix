{
  enabled = false;
  role = "family";
  system = "x86_64-linux";

  users = [ "bensuperpc" ];
  deployUser = "bensuperpc";

  profiles = [ "platform/gpu-intel-skylake" ];
}
