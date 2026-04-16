{
  role = "workstation";
  system = "x86_64-linux";
  ip = "192.168.1.27";

  users = [ "bensuperpc" ];
  deployUser = "bensuperpc";

  appProfiles = [ "apps/games" "apps/docker" "apps/communication" "apps/files" ];
  hwProfiles = [ "platform/gpu-intel-skylake" "platform/bluetooth" "platform/wireless" ];
}
