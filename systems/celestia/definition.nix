{
  role = "family";
  system = "x86_64-linux";

  users = [ "bensuperpc" ];
  deployUser = "bensuperpc";

  hwProfiles = [ "platform/gpu-intel" ];
}
