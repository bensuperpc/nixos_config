{
  enabled = false;
  role = "desktop";
  system = "x86_64-linux";

  users = [ "bensuperpc" ];
  deployUser = "bensuperpc";

  appProfiles = [ "apps/development" "apps/games" "apps/docker" "apps/browser" "apps/communication" "apps/torrent" "apps/files" ];
  platformProfiles = [ "platform/gpu-intel-skylake" ];
}
