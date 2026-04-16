{
  role = "desktop";
  system = "x86_64-linux";

  users = [ "bensuperpc" ];
  deployUser = "bensuperpc";

  appProfiles = [ "apps/development" "apps/games" "apps/docker" "apps/files" "apps/communication" ];
  hwProfiles = [ "platform/gpu-intel" ];
}
